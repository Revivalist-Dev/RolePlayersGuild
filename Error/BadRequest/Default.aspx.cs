using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Error.BadRequest
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            litErrorMessage.Text = "<p>Oh no! There seems to have been some error. Stop breaking things, please, this is all your fault! No, we're just kidding. This is obviously our fault. We are sorry this happened; we will be receiving an email on our end telling us about this error very soon and we promise we'll work on fixing it as soon as possible. Meanwhile, if you'd like to help out, you could <a href=\"/Report/\">reach out to the staff</a> and tell us what, exactly, you were doing when this error happened. This is not, however, required.</p>";
            if (Request.QueryString["type"] != null && Request.QueryString["type"].ToString().Length > 0)
            {
                if (Session["UserID"] == null)
                {
                    divMarketing.Visible = true;
                }
                switch (Request.QueryString["type"])
                {
                    case "NoCharacter":
                        litErrorMessage.Text = "<p>Sorry, but that character doesn't exist. If you came here by clicking a link it's possible that the character linked was deleted at some point.</p>";
                        break;
                    case "NoGallery":
                        litErrorMessage.Text = "<p>Sorry, but that character gallery doesn't exist. If you came here by clicking a link it's possible that the character gallery linked was deleted at some point.</p>";
                        break;
                }
            }
        }
    }
}