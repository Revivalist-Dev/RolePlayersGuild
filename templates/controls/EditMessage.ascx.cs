using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditMessage : System.Web.UI.UserControl
    {
        public string MessageType { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            litMessage.Text = MessageType;
            switch (MessageType)
            {
                case "New Thread":
                    break;
                case "Edit Thread":
                    btnCreateThread.Text = "Save Changes";
                    break;
                case "Add Message":
                    pnlTitle.Visible = false;
                    btnCreateThread.Text = "Submit Post";
                    break;
                case "Edit Message":
                    pnlTitle.Visible = false;
                    btnCreateThread.Text = "Save Changes";
                    break;
                default:
                    break;
            }

        }
    }
}