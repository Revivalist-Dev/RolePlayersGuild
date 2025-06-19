using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.Characters
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
            //divCharacterType.Visible = (CookieFunctions.UserTypeID == 3);
            //aDeleteCharacter.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2);

            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                {
                    SelectedCharacterID = QueryStringValue;
                    txtCharacterID.Text = QueryStringValue.ToString();
                }
                PopulateTools();
            }
        }
        //protected void lbCharacters_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    ViewState["SelectedUserID"] = null;
        //    SelectedCharacterID = int.Parse(lbCharacters.SelectedValue.ToString());
        //    PopulateTools();
        //}
        void PopulateTools()
        {
            if (SelectedCharacterID > 0)
            {
                DataRow SelectedCharacter = DataFunctions.Records.GetCharacter(SelectedCharacterID);
                if (SelectedCharacter != null)
                {
                    litCharacterName.Text = SelectedCharacter["CharacterDisplayName"].ToString();
                    ddlType.SelectedValue = SelectedCharacter["TypeID"].ToString();
                    divTools.Visible = true;
                    lnkJumpToUser.NavigateUrl = "/Admin/Users?id=" + SelectedUserID.ToString();
                }
                else {
                    pnlMessage.Visible = true;
                    pnlMessage.CssClass = "alert alert-danger";
                    litMessage.Text = "No character with that ID.";
                }
                //ddlCharacterType.SelectedValue = SelectedCharacter["TypeID"].ToString();
            }
            else { divTools.Visible = false; }
        }
        //protected void btnDeletePrimary_Click(object sender, EventArgs e)
        //{

        //    DataRow drCharacterImage = DataFunctions.Records.GetDisplayImage(SelectedCharacterID);
        //    if (drCharacterImage != null)
        //    {
        //        string directoryVirtual = ConfigurationManager.AppSettings["CharacterImagesFolder"].ToString();
        //        string directoryPhysical = HttpContext.Current.Server.MapPath(directoryVirtual);
        //        string ImageName = (string)drCharacterImage["CharacterImageURL"];
        //        if (File.Exists(directoryPhysical + "fullimg_" + ImageName))
        //        {
        //            File.Copy(directoryPhysical + "fullimg_" + ImageName, directoryPhysical + "deletedimg_" + ImageName);
        //            File.Delete(directoryPhysical + "fullimg_" + ImageName);
        //        }
        //        if (File.Exists(directoryPhysical + "thumbimg_" + ImageName))
        //        {
        //            File.Delete(directoryPhysical + "thumbimg_" + ImageName);
        //        }
        //        DataFunctions.Deletes.DeleteRows("Delete From Character_Images Where CharacterImageID = @ParamOne", drCharacterImage["CharacterImageID"]);

        //        DataTable AdminUsers = DataFunctions.Tables.GetDataTable("SELECT Characters.CharacterID, Users.UserID FROM Users INNER JOIN Characters ON Users.UserID = Characters.UserID Where Characters.IsStaff = 1 And Users.UserTypeID = 3;");
        //        if (AdminUsers.Rows.Count > 0)
        //        {
        //            foreach (DataRow rowUser in AdminUsers.Rows)
        //            {
        //                //var rpgThreads = new rpgDBTableAdapters.ThreadsTableAdapter();
        //                int ThreadID = DataFunctions.Inserts.CreateNewThread("Admin Only: Character Image Deleted By Staff");

        //                //var rpgThreadMessages = new rpgDBTableAdapters.Thread_MessagesTableAdapter();
        //                DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "User " + Session["UserID"].ToString() + " removed <a href='/UserFiles/CharacterImages/deletedimg_" + ImageName + "' target='_blank'>this image</a> from Character " + SelectedCharacterID + "'s Gallery.");

        //                //var rpgThreadUsers = new rpgDBTableAdapters.Thread_UsersTableAdapter();
        //                DataFunctions.Inserts.InsertThreadUser(int.Parse(rowUser["UserID"].ToString()), ThreadID, 2, int.Parse(rowUser["CharacterID"].ToString()), 1);
        //            }
        //        }
        //        pnlMessage.Visible = true;
        //        pnlMessage.CssClass = "alert alert-success";
        //        litMessage.Text = "Character Display Image has been deleted.";
        //    }
        //}

        protected void chkIsStaff_CheckedChanged(object sender, EventArgs e)
        {
        }

        protected void btnDeleteCharacter_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteCharacter(SelectedCharacterID);
            Response.Redirect("/Admin/Characters/");
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            DataFunctions.Updates.UpdateRow("UPDATE Characters SET TypeID = @ParamTwo WHERE (CharacterID = @ParamOne)", SelectedCharacterID, ddlType.SelectedValue);
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "Character type has been changed.";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int charaID = 0;

            if (int.TryParse(txtCharacterID.Text, out charaID))
            {
                ViewState["SelectedUserID"] = null;
                SelectedCharacterID = charaID;
                PopulateTools();
            }
        }
        protected void btnMarkForReview_Click(object sender, EventArgs e)
        {
            MiscFunctions.MarkCharacterForReview(SelectedCharacterID);
        }
        //protected void ddlCharacterType_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    DataFunctions.Updates.UpdateRow("UPDATE Characters SET TypeID = @ParamTwo WHERE (CharacterID = @ParamOne)", SelectedCharacterID, ddlCharacterType.SelectedValue);
        //}
    }
}