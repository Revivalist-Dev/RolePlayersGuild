using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class ChatRoom : System.Web.UI.UserControl
    {
        public string RatingID { get; set; }
        public string ChatRoomName { get; set; }
        public string ChatRoomID { get; set; }
        public int UserID { get { return CookieFunctions.UserID; } set { } }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divChatAd.Visible = false;
            }
            litChatRoomName.Text = ChatRoomName;
            txtChatPostContent.Attributes.Add("MaxLength", "475");
            if (!Page.IsPostBack)
            {
            }
        }
    }
}