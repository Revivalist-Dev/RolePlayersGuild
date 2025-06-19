using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class SendAsChanger : System.Web.UI.UserControl
    {
        public delegate void ChangeSendAs(object sender, EventArgs e);
        public event ChangeSendAs OnChangeSendAs;
        protected void DisplayCurrentSendingCharacter()
        {
            DataRow drCharacter = null;
            if (DataFunctions.CurrentSendAsCharacterID == 0)
            {
                drCharacter = DataFunctions.Records.GetDataRow("Select CharacterID, DisplayImageURL, CharacterNameClass, CharacterDisplayName From CharactersWithDetails Where UserID = @ParamOne And CharacterStatusID = 1", 0, CookieFunctions.UserID);

            }
            else
            {
                drCharacter = DataFunctions.Records.GetDataRow("Select CharacterID, DisplayImageURL, CharacterNameClass, CharacterDisplayName From CharactersWithDetails Where CharacterID = @ParamOne And CharacterStatusID = 1", 0, DataFunctions.CurrentSendAsCharacterID);
                if (drCharacter == null)
                {
                    drCharacter = DataFunctions.Records.GetDataRow("Select CharacterID, DisplayImageURL, CharacterNameClass, CharacterDisplayName From CharactersWithDetails Where UserID = @ParamOne And CharacterStatusID = 1", 0, CookieFunctions.UserID);
                }
            }
            if (drCharacter != null)
            {
                aSendAs.Attributes.Add("style", "background-image: url('" + StringFunctions.DisplayImageString(drCharacter[1].ToString(), "thumb") + "');");
                DataFunctions.CurrentSendAsCharacterID = (int)drCharacter[0];
                hdnCurrentCharacterID.Value = drCharacter[0].ToString();
                hdnCharacterThumbnail.Value = StringFunctions.DisplayImageString(drCharacter[1].ToString(), "thumb");
                hdnCharacterNameClass.Value = drCharacter[2].ToString();
                hdnCharacterDisplayName.Value = drCharacter[3].ToString();
            }
            rptMyCharacters.DataBind();
        }

        protected void rptMyCharacters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int SwitchToCharacterID = (int)drv["CharacterID"];
                Button btnCharacter = (Button)(e.Item.FindControl("btnCharacter"));
                if (DataFunctions.CurrentSendAsCharacterID == SwitchToCharacterID)
                {
                    btnCharacter.Visible = false;
                }
                else
                {
                    btnCharacter.CommandName = "SwitchCharacter";
                    btnCharacter.CommandArgument = SwitchToCharacterID.ToString();
                    btnCharacter.Text = drv["CharacterDisplayName"].ToString();
                    btnCharacter.Attributes.Add("OnClick", "Closepopups(); return true;");
                }
            }
        }

        protected void rptMyCharacters_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "SwitchCharacter":
                    DataFunctions.CurrentSendAsCharacterID = int.Parse(e.CommandArgument.ToString());
                    hdnCurrentCharacterID.Value = e.CommandArgument.ToString();
                    DisplayCurrentSendingCharacter();
                    break;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DisplayCurrentSendingCharacter();
            }
        }
    }
}