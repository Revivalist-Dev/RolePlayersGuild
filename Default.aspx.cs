using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (CookieFunctions.UserID != 0)
            {
                Response.Redirect("/My-Dashboard/");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {

            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());

            con.Open();
            SqlCommand GetCountOfFailedLoginAttemptsForIP = new SqlCommand("SELECT COUNT(IPAddress) AS Expr1 FROM Login_Attempts WHERE (AttemptWasSuccessful = 0) AND (IPAddress = @IP) AND (AttemptTimeStamp > dateadd(hour,-5,getdate()))", con);
            GetCountOfFailedLoginAttemptsForIP.Parameters.AddWithValue("IP", MiscFunctions.CurrentIP);
            int FailedLoginAttemptsForIP = int.Parse(GetCountOfFailedLoginAttemptsForIP.ExecuteScalar().ToString());

            if (FailedLoginAttemptsForIP > 15)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Your IP is blocked for 5 hours due to too many failed login attempts on more than one user.";
            }
            else {
                SqlCommand GetCountOfFailedLoginAttemptsForEmail = new SqlCommand("SELECT COUNT(AttemptedUsername) AS Expr1 FROM Login_Attempts WHERE (AttemptWasSuccessful = 0) AND (AttemptedUsername = @Email) AND (AttemptTimeStamp > dateadd(hour,-1,getdate()))", con);
                GetCountOfFailedLoginAttemptsForEmail.Parameters.AddWithValue("Email", txtEmailAddress.Text);
                int FailedLoginAttemptsForEmail = int.Parse(GetCountOfFailedLoginAttemptsForEmail.ExecuteScalar().ToString());
                if (FailedLoginAttemptsForEmail > 10)
                {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger";
                    litMessage.Text = "That account is locked for 1 hour due to too many (10) failed login attempts.";
                }
                else {
                    //var rpgUsers = new rpgDBTableAdapters.UsersTableAdapter();
                    DataRow SelectedUser = DataFunctions.Records.GetUser(txtEmailAddress.Text, txtPassword.Text); //rpgUsers.GetUserIDByEmailAndPassword(txtEmailAddress.Text, txtPassword.Text);
                    if (SelectedUser != null)
                    {
                       
                        MiscFunctions.SetUserInfo(SelectedUser);
                        HttpContext.Current.Response.Redirect("/My-Dashboard/");
                    }
                    else {
                        SqlCommand InsertLoginAttempt = new SqlCommand("INSERT INTO Login_Attempts (AttemptedUsername, AttemptedPassword, IPAddress, AttemptWasSuccessful) VALUES (@User,@Pass,@IP,@Success)", con);
                        InsertLoginAttempt.Parameters.AddWithValue("User", txtEmailAddress.Text);
                        InsertLoginAttempt.Parameters.AddWithValue("Pass", txtPassword.Text);
                        InsertLoginAttempt.Parameters.AddWithValue("IP", MiscFunctions.CurrentIP);
                        InsertLoginAttempt.Parameters.AddWithValue("Success", false);
                        InsertLoginAttempt.ExecuteNonQuery();
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "Those credentials are invalid.";
                    }
                }
            }
            con.Close();
        }
    }
}