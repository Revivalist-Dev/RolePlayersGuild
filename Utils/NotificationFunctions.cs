using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;

namespace RolePlayersGuild
{
    public class NotificationFunctions
    {
        static void SendNotificationEmail(string SendTo, string NotificationSubject, string NotificationBody)
        {
            if (!HttpContext.Current.Request.Url.Host.Contains("localhost"))
            {
                MailMessage m = new MailMessage();
                SmtpClient sc = new SmtpClient();
                m.IsBodyHtml = true;
                m.From = new MailAddress("no-reply@RolePlayersGuild.com", "Role-Players Guild");
                m.To.Add(SendTo);
                m.Subject = NotificationSubject;
                m.Body = NotificationBody;
                sc.Host = "smtp.host.com";
                sc.Port = 587;
                sc.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["SMTPUser"].ToString(), ConfigurationManager.AppSettings["SMTPPass"].ToString());
                sc.EnableSsl = true;
                sc.Send(m);
            }
        }
        public static void SendErrorEmail(StringBuilder ErrorBody)
        {
            if (!HttpContext.Current.Request.Url.Host.Contains("localhost"))
            {
                try
                {
                    MailMessage m = new MailMessage();
                    SmtpClient sc = new SmtpClient();
                    m.IsBodyHtml = false;
                    m.From = new MailAddress("errors@RolePlayersGuild.com");
                    m.To.Add("siteadmin@RolePlayersGuild.com");
                    m.Subject = "Error at RPG - " + DateTime.Now.ToString();
                    m.Body = ErrorBody.ToString();
                    //sc.Host = "email-smtp.us-west-2.amazonaws.com";
                    sc.Host = "mail.roleplayersguild.com";
                    sc.Port = 25;
                    //sc.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["SMTPUser"].ToString(), ConfigurationManager.AppSettings["SMTPPass"].ToString());
                    sc.Credentials = new System.Net.NetworkCredential("errors@RolePlayersGuild.com", "Password"); //Using hardcoded values to keep this as self-contained as possible in the event of a major error.
                    sc.EnableSsl = false;
                    sc.Send(m);

                }
                catch (Exception err)
                {
                    //Do nothing for now.
                }
            }
        }
        public static void NewItemAlert(string ItemID, object SenderCharacterID, string ContentType)
        {
            string MappedPath = HttpContext.Current.Server.MapPath("/templates/email/NewItemMessage.html");
            if (File.Exists(MappedPath))
            {
                string FileContents = File.ReadAllText(MappedPath);

                //var rpgCharacter = new rpgDBTableAdapters.CharactersWithDisplayImagesTableAdapter();
                //rpgDB.CharactersWithDisplayImagesDataTable dtCharacter = rpgCharacter.GetCharacterByCharacterID();
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                con.Open();
                var daCharacter = new SqlDataAdapter("SELECT * From CharactersWithDetails WHERE (CharacterID = @CharacterID)", con);
                daCharacter.SelectCommand.Parameters.AddWithValue("CharacterID", int.Parse(SenderCharacterID.ToString()));
                var dtCharacter = new DataTable();
                daCharacter.Fill(dtCharacter);
                DataTable dtRecipients = new DataTable();
                switch (ContentType)
                {
                    case "Story Post":
                    case "Message":
                        var daMessageNoticeRecipients = new SqlDataAdapter("SELECT Thread_Users.UserID, Thread_Users.ThreadID, Characters.CharacterDisplayName, Users.EmailAddress FROM Thread_Users INNER JOIN Users ON Thread_Users.UserID = Users.UserID INNER JOIN Characters ON Thread_Users.CharacterID = Characters.CharacterID Where Users.ReceivesThreadNotifications = 1 AND Thread_Users.ThreadID = @ThreadID", con);
                        daMessageNoticeRecipients.SelectCommand.Parameters.AddWithValue("ThreadID", ItemID);
                        daMessageNoticeRecipients.Fill(dtRecipients);
                        break;
                    case "Image Comment":
                        var daImageCommentNoticeRecipients = new SqlDataAdapter("SELECT Users.EmailAddress, imgs.CharacterImageID, Users.UserID FROM Users INNER JOIN Characters ON Users.UserID = Characters.UserID INNER JOIN Character_Images AS imgs ON Characters.CharacterID = imgs.CharacterID WHERE (Users.ReceivesImageCommentNotifications = 1) and imgs.CharacterImageID = @ImageID", con);
                        daImageCommentNoticeRecipients.SelectCommand.Parameters.AddWithValue("ImageID", ItemID);
                        daImageCommentNoticeRecipients.Fill(dtRecipients);
                        break;
                }
                con.Close();
                if (dtRecipients.Rows.Count > 0 && dtCharacter.Rows.Count > 0)
                {
                    foreach (DataRow Row in dtRecipients.Rows)
                    {
                        if (Row["UserID"].ToString() != dtCharacter.Rows[0]["UserID"].ToString())
                        {
                            string emailBody = FileContents;
                            emailBody = emailBody.Replace("[SENDERNAME]", dtCharacter.Rows[0]["CharacterDisplayName"].ToString());
                            emailBody = emailBody.Replace("[CONTENTTYPE]", ContentType);
                            emailBody = emailBody.Replace("[USERID]", Row["UserID"].ToString());
                            emailBody = emailBody.Replace("[USEREMAIL]", Row["EmailAddress"].ToString());
                            SendNotificationEmail(Row["EmailAddress"].ToString(), "[RPG] New " + ContentType + " from " + dtCharacter.Rows[0]["CharacterDisplayName"].ToString() + "!", emailBody);
                        }
                    }
                }
            }
        }
        public static void PasswordRecoveryNotification(string RecoveryKey, string YearDay, string MonthHour, string UserID, string Rand1, string Rand2, string Rand3)
        {

            string MappedPath = HttpContext.Current.Server.MapPath("/templates/email/PasswordRecovery.html");

            if (File.Exists(MappedPath))
            {
                string FileContents = File.ReadAllText(MappedPath);

                string RecipientEmail = DataFunctions.Scalars.GetSingleValue("Select EmailAddress from Users Where UserID = @ParamOne", UserID).ToString();
                if (RecipientEmail != null && RecipientEmail.Length > 0)
                {
                    //[RECOVERYKEY]&reckeytwo=&28[YEARDAY][RAND1]&usrid=[USERID]&usridtwo=[MONTHHOUR][RAND2]&chksum=[RAND3]
                    string emailBody = FileContents;
                    emailBody = emailBody.Replace("[RECOVERYKEY]", RecoveryKey);
                    emailBody = emailBody.Replace("[YEARDAY]", YearDay);
                    emailBody = emailBody.Replace("[MONTHHOUR]", MonthHour);
                    emailBody = emailBody.Replace("[USERID]", UserID);
                    emailBody = emailBody.Replace("[RAND1]", Rand1);
                    emailBody = emailBody.Replace("[RAND2]", Rand2);
                    emailBody = emailBody.Replace("[RAND3]", Rand3);
                    SendNotificationEmail(RecipientEmail, "[RPG] Password Recovery Alert", emailBody);
                }
            }
        }
        public static void MembershipAlert(string MembershipType, int RecipientID, string NoticeType)
        {

            string MappedPath = "";
            switch (NoticeType)
            {
                case "NewMember":
                    MappedPath = HttpContext.Current.Server.MapPath("/templates/email/NewMembershipSubscription.html");
                    break;
                case "CanceledMember":
                    MappedPath = HttpContext.Current.Server.MapPath("/templates/email/CanceledMembershipSubscription.html");
                    break;
            }
            if (File.Exists(MappedPath))
            {
                string FileContents = File.ReadAllText(MappedPath);

                string RecipientEmail = DataFunctions.Scalars.GetSingleValue("Select EmailAddress from Users Where UserID = @ParamOne", RecipientID).ToString();
                if (RecipientEmail != null && RecipientEmail.Length > 0)
                {
                    string emailBody = FileContents;
                    emailBody = emailBody.Replace("[MEMBERTYPE]", MembershipType);
                    SendNotificationEmail(RecipientEmail, "[RPG] Membership Alert", emailBody);
                }
            }
        }
        public static void TransactionAlert(string PurchasedItem, int RecipientID, string TransactionID, string PaymentAmount, string TransactionStatus)
        {

            string MappedPath = "";
            string SubjectLine = "";
            switch (TransactionStatus)
            {
                case "Received":
                    MappedPath = HttpContext.Current.Server.MapPath("/templates/email/PaymentReceivedMessage.html");
                    SubjectLine = "Payment Received";
                    break;
                case "Failed":
                    MappedPath = HttpContext.Current.Server.MapPath("/templates/email/PaymentFailedMessage.html");
                    SubjectLine = "Payment Failed";
                    break;
            }
            if (File.Exists(MappedPath))
            {
                string FileContents = File.ReadAllText(MappedPath);

                string RecipientEmail = DataFunctions.Scalars.GetSingleValue("Select EmailAddress from Users Where UserID = @ParamOne", RecipientID).ToString();
                if (RecipientEmail != null && RecipientEmail.Length > 0)
                {
                    string emailBody = FileContents;
                    emailBody = emailBody.Replace("[PURCHASEDITEM]", PurchasedItem);
                    emailBody = emailBody.Replace("[PAYMENTAMOUNT]", PaymentAmount);
                    emailBody = emailBody.Replace("[TRANSACTIONID]", TransactionID);
                    SendNotificationEmail(RecipientEmail, "[RPG] " + SubjectLine, emailBody);
                }
            }
        }

        public static void SendMessageToStaff(string ThreadTitle, string MessageContent)
        {
            DataTable AdminUsers = DataFunctions.Tables.GetDataTable("SELECT Characters.CharacterID, Characters.UserID FROM Characters INNER JOIN User_Badges ON Characters.CharacterID = User_Badges.AssignedToCharacterID WHERE (User_Badges.BadgeID = 3);");
            if (AdminUsers.Rows.Count > 0)
            {
                foreach (DataRow rowUser in AdminUsers.Rows)
                {
                    int ThreadID = DataFunctions.Inserts.CreateNewThread(ThreadTitle);
                    DataFunctions.Inserts.InsertMessage(ThreadID, 1450, MessageContent);
                    DataFunctions.Inserts.InsertThreadUser(int.Parse(rowUser["UserID"].ToString()), ThreadID, 2, int.Parse(rowUser["CharacterID"].ToString()), 1);
                }
            }
        }
    }
}