using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Chat_Rooms
{
    public partial class GetChatContent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form["ChatRoomID"] != null && Request.Form["UserID"] != null) /* && MiscFunctions.IsInternalReferrer)*/
            {
                //if (Request.Form["ChatRoomID"] != "2")
                //{
                    DataTable CountOfLocks = DataFunctions.Tables.GetDataTable("Select UserID From Chat_Room_Locks Where ChatRoomID = @ParamOne and UserID = @ParamTwo", Request.Form["ChatRoomID"], Request.Form["UserID"]);
                if (CountOfLocks.Rows.Count > 0)
                {
                    litMessage.Text = "<p>You have been locked out of this chat room. If you feel this has been done in error, please <a href=\"http://www.roleplayersguild.com/Report/\">file a report about this</a>.</p><p><strong>How long am I locked out?</strong></p><p>The duration of a chat lock is left to the discretion of the staff member who activated it. They may last anywhere between 24 hours to a week, depending on the severity of the offense.</p>";
                    pnlMessage.CssClass = "alert alert-danger";
                    pnlMessage.Visible = true;
                }
                else {
                    rptChatPosts.DataSource = sdsChatPosts;
                    rptChatPosts.DataBind();
                    DataRow TheChatRoom = DataFunctions.Records.GetChatRoomWithDetails(int.Parse(Request.Form["ChatRoomID"]));
                    string ChatDescription = "<p><strong>Universe:</strong> <a href=\"/Universe/?id=" + TheChatRoom["UniverseID"] + "\">" + TheChatRoom["UniverseName"] + " &raquo;</a></p>" +
                        "<p><strong>Content Rating:</strong> " + TheChatRoom["ContentRating"] + " - " + TheChatRoom["ContentRatingDescription"] + "</p>" +
                        "<div data-linkify>" + TheChatRoom["ChatRoomDescription"].ToString() + "</div>";

                    litChatDescription.Text = ChatDescription;
                    }
                //}
                //else {
                //    litMessage.Text = "<p>The OOC Chat has been disabled and moved to Chatzy: <a href=\"http://us21.chatzy.com/roleplayersguild\" target=\"_blank\">http://us21.chatzy.com/roleplayersguild</a>.</p>";
                //    pnlMessage.CssClass = "alert alert-danger";
                //    pnlMessage.Visible = true;
                //}
            }
        }
        public string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
        }
        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}

        //protected void rptChatPosts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        DataRowView drv = e.Item.DataItem as DataRowView;
        //        int CharacterID = (int)drv["CharacterID"];
        //        HyperLink lnkCreator = (HyperLink)(e.Item.FindControl("lnkCreator"));
        //        lnkCreator.Style.Add("background-image", "url('" + StringFunctions.DisplayImageString(drv["DisplayImageURL"].ToString(), "thumb") + "');");
        //        lnkCreator.NavigateUrl = "/Character?id=" + CharacterID.ToString();
        //    }
        //}
    }
}