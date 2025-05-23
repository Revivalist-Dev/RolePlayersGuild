using System;
using System.Data;
using System.Data.SqlClient;

namespace RolePlayersGuild.Admin.Mass_Message
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (CookieFunctions.UserTypeID != 3)
            { Response.Redirect("/"); }


        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            int AdminCharacterID = (int)DataFunctions.Scalars.GetSingleValue("SELECT CharacterID FROM Characters WHERE (TypeID = 2) AND (UserID = @ParamOne)", CookieFunctions.UserID);

            if (AdminCharacterID == 0)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "You don't seem to have an admin character to send this as...";
            }
            else {
                if (txtMassMessage.Text.Length > 0)
                {
                    DataTable dt = DataFunctions.Tables.GetDataTable("SELECT Users.UserID, MAX(Characters.CharacterID) AS CharacterID FROM Users INNER JOIN Characters ON Users.UserID = Characters.UserID GROUP BY Users.UserID;");
                    if (dt.Rows.Count > 0)
                    {
                        SqlConnection MassMessageConn = DataFunctions.Connections.GetOpenRPGDBConn();
                        foreach (DataRow rowUser in dt.Rows)
                        {
                            //var rpgThreads = new rpgDBTableAdapters.ThreadsTableAdapter();
                            int ThreadID = DataFunctions.Inserts.CreateNewThread(MassMessageConn, "[RPG] - Mass Message - " + txtMessageTitle.Text);

                            //var rpgThreadMessages = new rpgDBTableAdapters.Thread_MessagesTableAdapter();
                            DataFunctions.Inserts.InsertMessage(MassMessageConn, ThreadID, AdminCharacterID, txtMassMessage.Text + "<br><br><div class=\"alert alert-info\">If you have any questions or concerns about this message, please <a href='/Report'>contact the staff</a> right away.</div>");

                            //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
                            DataFunctions.Inserts.InsertThreadUser(MassMessageConn, int.Parse(rowUser["UserID"].ToString()), ThreadID, 2, int.Parse(rowUser["CharacterID"].ToString()), 1);
                        }
                        MassMessageConn.Close();
                    }
                    Response.Redirect("/My-Threads/");
                }
            }
        }
    }
}