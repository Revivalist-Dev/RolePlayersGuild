using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Report
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
        }

        protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
        {
            //DataTable AdminUsers = DataFunctions.Tables.GetDataTable("SELECT Characters.CharacterID, Characters.UserID FROM Characters INNER JOIN User_Badges ON Characters.CharacterID = User_Badges.AssignedToCharacterID WHERE (User_Badges.BadgeID = 3);");
            //if (AdminUsers.Rows.Count > 0)
            //{
            //    foreach (DataRow rowUser in AdminUsers.Rows)
            //    {
            //        //var rpgThreads = new rpgDBTableAdapters.ThreadsTableAdapter();
            //        int ThreadID = DataFunctions.Inserts.CreateNewThread("Staff Only: Issue Reported");

            //        //var rpgThreadMessages = new rpgDBTableAdapters.Thread_MessagesTableAdapter();
            //        DataFunctions.Inserts.InsertMessage(ThreadID, 1450, );

            //        //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
            //        DataFunctions.Inserts.InsertThreadUser(int.Parse(rowUser["UserID"].ToString()), ThreadID, 2, int.Parse(rowUser["CharacterID"].ToString()), 1);
            //    }
            //}
            NotificationFunctions.SendMessageToStaff("[Staff] - Issue Reported", "New issue has been reported. Please make sure it's assigned to the proper person. <a href=\"http://www.roleplayersguild.com/Admin/ToDo/\">View to-do items.</a>");
            FormView1.Visible = false;
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "Your report has been submitted. The staff will look into it as soon as possible. If a response is needed, they will contact you via a thread. Thank you!";
        }
    }
}