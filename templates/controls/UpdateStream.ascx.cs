using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class UpdateStream : System.Web.UI.UserControl
    {
        private int UserID
        {
            get
            {
                return CookieFunctions.UserID;
            }
            set
            {
                CookieFunctions.UserID = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            txtPostToStream.Attributes.Add("MaxLength", "475");
            if (!Page.IsPostBack)
            {
                //DisplayCurrentSendingCharacter();
                string SettingDesc = DataFunctions.Scalars.GetSingleValue("Select StreamSettingDescription From General_Settings").ToString();
                litWhereWeAre.Text = SettingDesc;
                DateTime StreamLockDateTime;

                if (DateTime.TryParse(DataFunctions.Scalars.GetSingleValue("Select StreamLockDateTime from Users where UserID = @ParamOne", CookieFunctions.UserID).ToString(), out StreamLockDateTime))
                {
                    if (StreamLockDateTime <= DateTime.Now.AddMinutes(30))
                    {
                        pnlLockOutMessage.Visible = true;
                        divSubmitPost.Visible = false;
                    }
                }
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);

        }

        //protected void DisplayCurrentSendingCharacter()
        //{
        //    DataRow drCharacter = null;
        //    if (DataFunctions.CurrentSendAsCharacterID == 0)
        //    {
        //        drCharacter = DataFunctions.Records.GetDataRow("Select CharacterID, DisplayImageURL From CharactersWithDetails Where UserID = @ParamOne", 0, UserID);
        //    }
        //    else
        //    {
        //        drCharacter = DataFunctions.Records.GetDataRow("Select CharacterID, DisplayImageURL From CharactersWithDetails Where CharacterID = @ParamOne", 0, DataFunctions.CurrentSendAsCharacterID);
        //    }
        //    if (drCharacter != null)
        //    {
        //        aSendAs.Attributes.Add("style", "background-image: url('" + StringFunctions.DisplayImageString(drCharacter[1].ToString(), "thumb") + "');");
        //        DataFunctions.CurrentSendAsCharacterID = (int)drCharacter[0];
        //        //DataFunctions.Records.GetDataRow("Select CharacterDisplayImage, ")
        //    }
        //    rptMyCharacters.DataBind();
        //}

        //protected void rptMyCharacters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        DataRowView drv = e.Item.DataItem as DataRowView;
        //        int SwitchToCharacterID = (int)drv["CharacterID"];
        //        Button btnCharacter = (Button)(e.Item.FindControl("btnCharacter"));
        //        if (DataFunctions.CurrentSendAsCharacterID == SwitchToCharacterID)
        //        {
        //            btnCharacter.Visible = false;
        //        }
        //        else
        //        {
        //            btnCharacter.CommandName = "SwitchCharacter";
        //            btnCharacter.CommandArgument = SwitchToCharacterID.ToString();
        //            btnCharacter.Text = drv["CharacterDisplayName"].ToString();
        //            btnCharacter.Attributes.Add("OnClick", "Closepopups(); return true;");
        //        }
        //    }
        //}

        //protected void rptMyCharacters_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{
        //    switch (e.CommandName)
        //    {
        //        case "SwitchCharacter":
        //            DataFunctions.CurrentSendAsCharacterID = int.Parse(e.CommandArgument.ToString());
        //            DisplayCurrentSendingCharacter();
        //            break;
        //    }
        //}

        public string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
        }
        protected void btnPostToStream_Click(object sender, EventArgs e)
        {
            DateTime StreamLockDateTime;

            if (DateTime.TryParse(DataFunctions.Scalars.GetSingleValue("Select StreamLockDateTime from Users where UserID = @ParamOne", CookieFunctions.UserID).ToString(), out StreamLockDateTime))
            {
                if (StreamLockDateTime <= DateTime.Now.AddMinutes(30))
                {
                    pnlLockOutMessage.Visible = true;
                    divSubmitPost.Visible = false;
                }
            }
            else
            {
                if (txtPostToStream.Text.Replace(" ", "").Length > 0)
                {
                    int InsertSubstringValue = 475;
                    if (txtPostToStream.Text.Length < 475)
                    { InsertSubstringValue = txtPostToStream.Text.Length; }
                    DataFunctions.Inserts.InsertRow("INSERT INTO UpdateStream (StreamPostContent, StreamPostMadeByCharacterID) VALUES (@ParamOne,@ParamTwo)", HttpUtility.HtmlEncode(txtPostToStream.Text.Substring(0, InsertSubstringValue)), DataFunctions.CurrentSendAsCharacterID);
                    txtPostToStream.Text = "";
                    rptSteamPosts.DataBind();
                }
            }
        }

        protected void rptSteamPosts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int CharacterID = (int)drv["StreamPostMadeByCharacterID"];
                HyperLink lnkCreator = (HyperLink)(e.Item.FindControl("lnkCreator"));
                lnkCreator.Style.Add("background-image", "url('" + StringFunctions.DisplayImageString(drv["DisplayImageURL"].ToString(), "thumb") + "');");
                lnkCreator.NavigateUrl = "/Character?id=" + CharacterID.ToString();
            }
        }

        protected void btnRefreshStream_Click(object sender, EventArgs e)
        {
            DateTime StreamLockDateTime;

            if (DateTime.TryParse(DataFunctions.Scalars.GetSingleValue("Select StreamLockDateTime from Users where UserID = @ParamOne", CookieFunctions.UserID).ToString(), out StreamLockDateTime))
            {
                if (StreamLockDateTime <= DateTime.Now.AddMinutes(30))
                {
                    pnlLockOutMessage.Visible = true;
                    divSubmitPost.Visible = false;
                }
            }
            else
            {
                rptSteamPosts.DataBind();
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            rptSteamPosts.DataBind();
        }
        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}
    }
}