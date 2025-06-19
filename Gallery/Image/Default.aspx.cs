using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Gallery.Image
{
    public partial class Default : System.Web.UI.Page
    {
        private int ImageOwnerUserID
        {
            get
            {
                if (ViewState["ImageOwnerUserID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["ImageOwnerUserID"]);
            }
            set
            {
                ViewState["ImageOwnerUserID"] = value;
            }
        }
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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["ImageID"] != null && Request.QueryString["ImageID"].ToString().Length > 0)
            {
                DataTable dtCharacterImage = DataFunctions.Tables.GetDataTable("Select * From Character_Images Where CharacterImageID = @ParamOne", Request.QueryString["ImageID"].ToString());



                if (dtCharacterImage.Rows.Count > 0)
                {             
                    if (bool.Parse(dtCharacterImage.Rows[0]["IsMature"].ToString()))
                    {
                        HtmlGenericControl divAd = Master.Master.FindControl("divAd") as HtmlGenericControl;
                        divAd.Visible = false;
                    }
                    aBackToGallery.HRef = "/Gallery?id=" + dtCharacterImage.Rows[0]["CharacterID"].ToString();
                    if (UserID != 0)
                    {
                        ImageOwnerUserID = DataFunctions.Scalars.GetUserID((int)dtCharacterImage.Rows[0]["CharacterID"]);

                        int intBlockID = 0;
                        bool UserLoggedInIsBlocked = false;
                        bool UserViewedIsBlocked = false;
                        int ViewedUser = ImageOwnerUserID;
                        int LoggedInUser = (int)Session["UserID"];
                        intBlockID = DataFunctions.Scalars.GetBlockRecordID(ViewedUser, LoggedInUser);
                        UserViewedIsBlocked = (intBlockID != 0); //ViewedUser Is Blocked by LoggedInUser
                        UserLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(LoggedInUser, ViewedUser) != 0); //LoggedInUser Is Blocked by ViewedUser

                        if (UserViewedIsBlocked || UserLoggedInIsBlocked)
                        { Response.Redirect("/Character?id=" + dtCharacterImage.Rows[0]["CharacterID"].ToString()); }

                        if (ImageOwnerUserID == UserID || CookieFunctions.IsStaff)
                        {
                            //UpdatePanel3.Visible = false;
                            lnkDeleteImage.Visible = true;
                            aEditImage.Visible = true;
                            aEditImage.HRef = "/My-Galleries/Edit-Gallery/?Mode=Edit&GalleryID=" + dtCharacterImage.Rows[0]["CharacterID"].ToString() + "&ImageID=" + Request.QueryString["ImageID"].ToString();
                            if (ImageOwnerUserID == UserID)
                            {
                                DataFunctions.Updates.UpdateRow("Update Character_Image_Comments Set IsRead = 1 Where ImageID = @ParamOne", Request.QueryString["ImageID"]);
                            }
                        }
                    }
                    else { divImageCommentSection.Visible = false; }
                    imgGalleryImage.ImageUrl = StringFunctions.DisplayImageString(dtCharacterImage.Rows[0]["CharacterImageURL"].ToString(), "full");
                    if (dtCharacterImage.Rows[0]["ImageCaption"].ToString().Length > 0)
                    {
                        pnlImageCaption.Visible = true;
                        pnlImageCaption.Controls.Add(new LiteralControl(dtCharacterImage.Rows[0]["ImageCaption"].ToString()));
                    }
                }
                else { Response.Redirect("/", true); }
                //lnkBackToProfile.NavigateUrl = "/Character?id=" + Request.QueryString["id"].ToString();
            }
            else { Response.Redirect("/", true); }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);

        }

        protected void btnDeleteImage_Click(object sender, EventArgs e)
        {
            DataRow drCharacterImage = DataFunctions.Records.GetImage(int.Parse(Request.QueryString["ImageID"].ToString()));
            if (drCharacterImage != null)
            {
                ImageFunctions.DeleteImage(drCharacterImage["CharacterImageURL"].ToString());
                DataFunctions.Deletes.DeleteRows("Delete From Character_Images Where CharacterImageID = @ParamOne", Request.QueryString["ImageID"].ToString());
                Response.Redirect("/Gallery?id=" + drCharacterImage["CharacterID"].ToString(), false);
            }
        }

        public string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
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

        protected void btnPostComment_Click(object sender, EventArgs e)
        {
            if (txtCommentContent.Text.Trim().Length > 0)
            {
                DataFunctions.Inserts.InsertRow("INSERT INTO Character_Image_Comments (CharacterID, ImageID, CommentText) VALUES (@ParamOne,@ParamTwo,@ParamThree)", DataFunctions.CurrentSendAsCharacterID, Request.QueryString["ImageID"], txtCommentContent.Text);
                NotificationFunctions.NewItemAlert(Request.QueryString["ImageID"], DataFunctions.CurrentSendAsCharacterID, "Image Comment");
            }
            txtCommentContent.Text = "";
            rptComments.DataBind();
        }
        //protected string ColorName(object TypeID)
        //{
        //    return StringFunctions.NameColorClass((int)TypeID);
        //}

        protected void rptComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int CharacterID = (int)drv["CharacterID"];
                HyperLink lnkCreator = (HyperLink)(e.Item.FindControl("lnkCreator"));
                lnkCreator.Style.Add("background-image", "url('" + StringFunctions.DisplayImageString(drv["DisplayImageURL"].ToString(), "thumb") + "');");
                lnkCreator.NavigateUrl = "/Character?id=" + CharacterID.ToString();
                //if (ImageOwnerUserID == UserID)
                //{
                //    Button btnCreateThread = (Button)(e.Item.FindControl("btnCreateThread"));
                //    btnCreateThread.Visible = true;
                //}

                if (UserID > 0 && (ImageOwnerUserID == UserID || CookieFunctions.IsStaff || UserID == (int)drv["UserID"]))
                {
                    //HtmlAnchor aEditComment = (HtmlAnchor)(e.Item.FindControl("aEditComment"));
                    HtmlAnchor aDeleteComment = (HtmlAnchor)(e.Item.FindControl("aDeleteComment"));
                    aDeleteComment.Visible = true;
                    //aEditComment.Visible = true;
                    //aEditComment.HRef = "/Gallery/Image/Edit-Comment?id=" + drv["ImageCommentID"].ToString() + "&img=" + drv["ImageID"];
                    //Gallery/Image/Edit-Comment?id=<%# Eval("ImageCommentID") %>
                }
            }
        }

        protected void btnDeleteComment_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteRows("Delete from Character_Image_Comments where ImageCommentID = @ParamOne", hdnCommentToDelete.Value);
            rptComments.DataBind();
        }
    }
}
