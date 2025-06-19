using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Unsubscribe
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            litMessage.Text = "The information provided is incorrect.";
            if (Request.QueryString["UserID"].ToString() != null && Request.QueryString["Key"].ToString() != null)
            {
                DataTable dt = new DataTable();
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                con.Open();
                var da = new SqlDataAdapter("Select * From Users Where UserID = @UserID and EmailAddress = @Email", con);
                da.SelectCommand.Parameters.AddWithValue("Email", Request.QueryString["Key"].ToString());
                da.SelectCommand.Parameters.AddWithValue("UserID", Request.QueryString["UserID"].ToString());
                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    da.UpdateCommand = new SqlCommand("UPDATE Users SET ReceivesThreadNotifications = 0, ReceivesImageCommentNotifications = 0 WHERE (UserID = @ID);", con);
                    da.UpdateCommand.Parameters.AddWithValue("ID", Request.QueryString["UserID"].ToString());
                    da.UpdateCommand.ExecuteNonQuery();
                    litMessage.Text = "You are now unsubscribed.";
                }
                con.Close();
            }
        }
    }
}