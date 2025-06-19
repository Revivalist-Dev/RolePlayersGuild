using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.CharactersUnderReview
{
    public partial class Default : System.Web.UI.Page
    {
        public int SelectedCharacterID
        {
            get
            {
                if (ViewState["SelectedCharacterID"] != null)
                {
                    return (int)ViewState["SelectedCharacterID"];
                }
                return 0;
            }
            set
            {
                ViewState["SelectedCharacterID"] = value;
            }
        }
        public int SelectedUserID
        {
            get
            {
                if (ViewState["SelectedUserID"] != null)
                {
                    return (int)ViewState["SelectedUserID"];
                }
                else if (ViewState["SelectedCharacterID"] != null)
                {
                    int UserID = DataFunctions.Scalars.GetUserID((int)ViewState["SelectedCharacterID"]);
                    ViewState["SelectedUserID"] = UserID;
                    return UserID;
                }
                return 0;
            }
            set
            {
                ViewState["SelectedUserID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                { SelectedCharacterID = QueryStringValue; }
                PopulateTools();
            }
        }
        protected void lbCharacters_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["SelectedUserID"] = null;
            SelectedCharacterID = int.Parse(lbCharacters.SelectedValue.ToString());
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedCharacterID > 0)
            {
                DataRow SelectedCharacter = DataFunctions.Records.GetCharacter(SelectedCharacterID);
                litCharacterName.Text = SelectedCharacter["CharacterDisplayName"].ToString();
                divTools.Visible = true;
                lnkJumpToUser.NavigateUrl = "/Admin/Users?id=" + SelectedUserID.ToString();
            }
            else { divTools.Visible = false; }
        }

        protected void btnUnlockCharacter_Click(object sender, EventArgs e)
        {
            DataFunctions.RunStatement("Update Characters Set CharacterStatusID = 1 Where CharacterID = @ParamOne", SelectedCharacterID);
            Response.Redirect("/Character/?id=" + SelectedCharacterID.ToString());
        }
    }
}