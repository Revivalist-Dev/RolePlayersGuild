using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class UserNav : System.Web.UI.UserControl
    {
        protected int UserID { get { return CookieFunctions.UserID; } set { } }
        public string CurrentParent { get; set; }
        public int CurrentItemID { get; set; }
        public int ItemCreatorID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (CurrentParent)
            {
                case "Mailbox":
                    divThreadFolders.Visible = true;
                    //ulMailBoxSubNav.Visible = true;
                    //liMailbox.Attributes.Add("class", "CurrentParent");
                    break;
                case "Stories":
                    divStoryNav.Visible = true;
                    aContactOwner.HRef = "/Writer/?id=" + ItemCreatorID;
                    aPosts.HRef = "/Story/Posts/?storyid=" + CurrentItemID;
                    aStoryDescription.HRef = "/Story/?id=" + CurrentItemID;
                    break;
                default:
                    break;
            }
            //int UnreadThreadsCount = DataFunctions.Scalars.GetUnreadThreadCount(Session["UserID"]);
            //if (UnreadThreadsCount > 0)
            //{ spanThreadBadge.Visible = true; spanThreadBadge.InnerText = UnreadThreadsCount.ToString(); }

            //int UnreadImageCommentsCount = DataFunctions.Scalars.GetUnreadImageCommentCountByUserID(Session["UserID"]);
            //if (UnreadImageCommentsCount > 0)
            //{ spanImageCommentBadge.Visible = true; spanImageCommentBadge.InnerText = UnreadImageCommentsCount.ToString(); }

            if (CookieFunctions.IsStaff)
            {
                aAdminConsole.Visible = true;
            }
            sdsQuickLinks.SelectParameters[0].DefaultValue = CookieFunctions.UserID.ToString();
            sdsQuickLinks.DataBind();
        }

        //protected void lnkLogout_Click(object sender, EventArgs e)
        //{
        //    //DataFunctions.Updates.UpdateRow("UPDATE Users SET LastAction = Null WHERE UserID = @ParamOne;", Session["UserID"]);
        //    //Session.Clear();
        //    //Session.Abandon();
        //    //CookieFunctions.RemoveEncryptedCookie("UserID");
        //    //CookieFunctions.RemoveEncryptedCookie("UserTypeID");
        //    //CookieFunctions.RemoveEncryptedCookie("HideStream");
        //    //CookieFunctions.RemoveEncryptedCookie("IsStaff");
        //    Response.Redirect("/Logout/");
        //}
    }
}