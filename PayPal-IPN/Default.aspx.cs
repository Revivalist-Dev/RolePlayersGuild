using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.PayPal_IPN
{
    public partial class Default : System.Web.UI.Page
    {
        protected string FullPostData()
        {
            string ReturnValue = "";
            foreach (string FormItem in HttpContext.Current.Request.Form)
            {
                ReturnValue += FormItem + " = " + HttpContext.Current.Request.Form[FormItem].ToString() + Environment.NewLine;
            }
            return ReturnValue;
        }
        protected void Page_Load(object sender, System.EventArgs e)
        {
            //Post back to either sandbox or live
            string strSandbox = "https://www.sandbox.paypal.com/cgi-bin/webscr";
            string strLive = "https://www.paypal.com/cgi-bin/webscr";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(strLive);

            //Set values for the request back
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            byte[] Param = Request.BinaryRead(HttpContext.Current.Request.ContentLength);
            string strRequest = Encoding.ASCII.GetString(Param);
            strRequest = strRequest + "&cmd=_notify-validate";
            req.ContentLength = strRequest.Length;

            //for proxy
            //Dim proxy As New WebProxy(New System.Uri("http://url:port#"))
            //req.Proxy = proxy

            //Send the request to PayPal and get the response
            StreamWriter streamOut = new StreamWriter(req.GetRequestStream(), Encoding.ASCII);
            streamOut.Write(strRequest);
            streamOut.Close();
            StreamReader streamIn = new StreamReader(req.GetResponse().GetResponseStream());
            string strResponse = streamIn.ReadToEnd();
            streamIn.Close();
            if (strResponse == "VERIFIED")
            {
                //check the payment_status is Completed
                //check that txn_id has not been previously processed
                //check that receiver_email is your Primary PayPal email
                //check that payment_amount/payment_currency are correct
                //process payment
                if (Request.Form["txn_type"] == "subscr_cancel")
                {
                    int UserID = GetUserID();
                    //DataFunctions.RunStatement("Update Memberships Set EndDate = GetDate() Where UserID = @ParamOne And EndDate is null", UserID);
                    DataFunctions.RunStatement("Insert into Transactions (PPSubscrID, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour)",
                            Request.Form["subscr_id"].ToString(),
                            UserID, "Subscription Canceled", FullPostData());
                    NotificationFunctions.MembershipAlert("", UserID, "CanceledMember");
                }
                else if (Request.Form["txn_type"] == "subscr_failed")
                {
                    int UserID = GetUserID();

                    DataFunctions.RunStatement("Insert into Transactions (PPTxnID, PPSubscrID, PPPaymentGross, PPPaymentDate, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive, @ParamSix, @ParamSeven)",
                             Request.Form["txn_id"].ToString(),
                             Request.Form["subscr_id"].ToString(),
                             Request.Form["payment_gross"].ToString(),
                             Request.Form["payment_date"].ToString(),
                             UserID, "Subscription Payment Failed", FullPostData());
                    NotificationFunctions.TransactionAlert(Request.Form["item_name"].ToString(), UserID, Request.Form["txn_id"].ToString(), "$" + Request.Form["payment_gross"].ToString(), "Failed");
                }
                else if (Request.Form["txn_type"] == "subscr_eot")
                {
                    string SubscriptionID = Request.Form["subscr_id"].ToString();
                    int UserID = GetUserID();
                    DataRow MembershipRecord = DataFunctions.Records.GetDataRow("Select * From Memberships Where EndDate is null and UserID = @ParamOne And PPSubscriptionID = @ParamTwo", 0, UserID, SubscriptionID);
                    DataFunctions.RunStatement("Insert into Transactions (PPSubscrID, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour)",
                            Request.Form["invoice"].ToString(),
                            SubscriptionID,
                            UserID, "Subscription EOT", FullPostData());
                    if (MembershipRecord != null)
                    {
                        DataFunctions.RunStatement("Update Memberships Set EndDate = GetDate() Where MembershipID = @ParamOne", MembershipRecord["MembershipID"]);
                        NotificationFunctions.MembershipAlert("", UserID, "CanceledMember");
                        DataFunctions.RunStatement("Delete From User_Badges Where UserID = @ParamOne AND (BadgeID = 10 Or BadgeID = 11 Or BadgeID = 12)", UserID);
                    }
                }
                else if (Request.Form["txn_type"] == "subscr_signup")
                {
                    int UserID = GetUserID();
                    int MembershipTypeID = 0;
                    int BadgeID = 0;
                    string MembershipType = "";
                    switch (Request.Form["amount3"])
                    {
                        case "10.00":
                            BadgeID = 12;
                            MembershipTypeID = 1;
                            MembershipType = "Bronze";
                            break;
                        case "20.00":
                            BadgeID = 11;
                            MembershipTypeID = 2;
                            MembershipType = "Silver";
                            break;
                        case "30.00":
                            BadgeID = 10;
                            MembershipTypeID = 3;
                            MembershipType = "Gold";
                            break;
                        case "5.00":
                            BadgeID = 15;
                            MembershipTypeID = 4;
                            MembershipType = "Platinum";
                            DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID) VALUES (@ParamOne,@ParamTwo)", UserID, 16);
                            break;
                    }
                    DataFunctions.RunStatement("Insert into Memberships (UserID, MembershipTypeID, PPSubscriptionID) VALUES (@ParamOne, @ParamTwo, @ParamThree)",
                        UserID, MembershipTypeID, Request.Form["subscr_id"].ToString());
                    DataFunctions.RunStatement("Insert into Transactions (PPSubscrID, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour)",
                            Request.Form["subscr_id"].ToString(), UserID, "Subscription Started", FullPostData());
                    NotificationFunctions.MembershipAlert(MembershipType, UserID, "NewMember");
                    DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID) VALUES (@ParamOne,@ParamTwo)", UserID, BadgeID);
                }
                else if (Request.Form["txn_type"] == "subscr_payment")
                {
                    if (Request.Form["payment_status"].ToString() == "Completed")
                    {
                        int UserID = GetUserID();

                        DataFunctions.RunStatement("Insert into Transactions (PPTxnID, PPSubscrID, PPPaymentGross, PPPaymentDate, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive, @ParamSix, @ParamSeven)",
                            Request.Form["txn_id"].ToString(),
                            Request.Form["subscr_id"].ToString(),
                            Request.Form["payment_gross"].ToString(),
                            Request.Form["payment_date"].ToString(),
                            UserID, "Subscription Payment Received", FullPostData());
                        NotificationFunctions.TransactionAlert(Request.Form["item_name"].ToString(), UserID, Request.Form["txn_id"].ToString(), "$" + Request.Form["payment_gross"].ToString(), "Received");
                    }
                    else { throw new Exception("Bad info on transaction IPN."); }
                }
                else if (Request.Form["txn_type"] == "web_accept")
                {
                    int UserID = GetUserID();
                    int BadgeID = 0;

                    decimal DonationAmount = decimal.Parse(Request.Form["payment_gross"].ToString());
                    if (DonationAmount > 0)
                    {
                        BadgeID = 1;
                        if (DonationAmount > 99) BadgeID = 2;

                        DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID) VALUES (@ParamOne,@ParamTwo)", UserID, BadgeID);
                        DataFunctions.RunStatement("Insert into Transactions (PPTxnID, PPPaymentGross, PPPaymentDate, UserID, TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive, @ParamSix)",
                                Request.Form["txn_id"].ToString(),
                                Request.Form["payment_gross"].ToString(),
                                Request.Form["payment_date"].ToString(),
                                UserID, "Donation Received", FullPostData());
                    }
                    else
                    {
                        DataFunctions.RunStatement("Insert into Transactions (TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo)", "Bad Donation Amount", FullPostData());
                    }
                }
                else
                {
                    DataFunctions.RunStatement("Insert into Transactions (TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo)", "Generic", FullPostData());
                }
            }
            else if (strResponse == "INVALID")
            {
                DataFunctions.RunStatement("Insert into Transactions (TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo)", "Invalid Transaction", FullPostData());
                throw new Exception("Invalid IPN Call.");
            }
            else {
                DataFunctions.RunStatement("Insert into Transactions (TransactionType, FullTransactionData) VALUES (@ParamOne, @ParamTwo)", "Other", FullPostData());
                throw new Exception("Bad IPN Call.");
            }
        }
        protected int GetUserID()
        {
            int UserID = 0;
            if (Request.Form["custom"].ToString().Length > 0 && Request.Form["custom"].ToString() != "0")
            { UserID = int.Parse(Request.Form["custom"].ToString()); }
            else { UserID = (int)DataFunctions.Scalars.GetSingleValue("Select Top 1 UserID from Transactions Where PPSubscrID = @ParamOne", Request.Form["subscr_id"].ToString()); }
            return UserID;
        }
    }
}