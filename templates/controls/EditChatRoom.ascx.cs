using HtmlAgilityPack;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditChatRoom : System.Web.UI.UserControl
    {

        private int ChatRoomID
        {
            get
            {
                if (ViewState["ChatRoomID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["ChatRoomID"]);
            }
            set
            {
                ViewState["ChatRoomID"] = value;
            }
        }
        public string ScreenStatus { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                switch (ScreenStatus)
                {
                    case "Edit":
                        if (Request.QueryString["id"] != null)
                        {
                            ChatRoomID = int.Parse(Request.QueryString["id"].ToString());
                            litTitle.Text = "Edit Chat Room";


                            DataRow TheChatRoom = DataFunctions.Records.GetChatRoomWithDetails(ChatRoomID);

                            int CurrentUserID = CookieFunctions.UserID;

                            if (TheChatRoom != null && ((TheChatRoom["UniverseOwnerID"] == DBNull.Value || ((int)TheChatRoom["UniverseOwnerID"] == CurrentUserID)) || (int)TheChatRoom["SubmittedByUserID"] == CurrentUserID))
                            {
                                txtChatRoomName.Text = TheChatRoom["ChatRoomName"].ToString();
                                txtChatRoomDescription.Text = TheChatRoom["ChatRoomDescription"].ToString();
                                ddlRating.SelectedValue = TheChatRoom["ContentRatingID"].ToString();
                                ddlUniverse.SelectedValue = TheChatRoom["UniverseID"].ToString();
                            }
                            else
                            {
                                Response.Redirect("/", true);
                            }
                        }
                        else
                        {
                            Response.Redirect("/", true);
                        }
                        break;
                    case "New":
                        lnkDeleteChatRoom.Visible = false;
                        litTitle.Text = "New Chat Room";
                        Page.Title = "New Chat Room on RPG";
                        break;
                }
            }
        }

        protected void btnCreateChatRoom_Click(object sender, EventArgs e)
        {

            HtmlDocument docVerseDesc = new HtmlDocument();
            docVerseDesc.LoadHtml(txtChatRoomDescription.Text);
            bool containsScript = docVerseDesc.DocumentNode.Descendants()
                                                    .Where(node => node.Name == "script")
                                                    .Any();
            if (containsScript)
            {
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-danger";
                litMessage.Text = "Script tags are not allowed.";
            }
            else {
                switch (ScreenStatus)
                {
                    case "Edit":
                        UpdateChatRoom();
                        Response.Redirect("/My-Chat-Rooms/");
                        break;
                    case "New":
                        int CurrentUserID = CookieFunctions.UserID;
                        ChatRoomID = DataFunctions.Inserts.CreateNewChatRoom(CurrentUserID);
                        NotificationFunctions.SendMessageToStaff("[Staff] - New Chat Room Submitted", "A new chat room has been submitted, <a href=\"/Admin/Chat-Rooms/\">please review</a>.");
                        UpdateChatRoom();
                        DataFunctions.AwardBadgeIfNotExisting(8, CurrentUserID);
                        Response.Redirect("/My-Chat-Rooms/?msg=submitcomplete");
                        break;
                }
            }
        }
        protected void UpdateChatRoom()
        {
            DataFunctions.Updates.UpdateRow("UPDATE Chat_Rooms SET ChatRoomName = @ParamTwo, ChatRoomDescription = @ParamThree, UniverseID = @ParamFour, ContentRatingID = @ParamFive WHERE (ChatRoomID = @ParamOne)",
                ChatRoomID, txtChatRoomName.Text, txtChatRoomDescription.Text, ddlUniverse.SelectedValue.ToString(), ddlRating.SelectedValue.ToString());
        }
        protected void btnDeleteChatRoom_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteChatRoom(ChatRoomID);
            Response.Redirect("/My-Chat-Rooms/", false);
        }
    }
}