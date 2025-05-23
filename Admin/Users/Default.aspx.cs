using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.Users
{
    public partial class Default : System.Web.UI.Page
    {
        int SelectedUserID
        {
            get
            {
                if (ViewState["SelectedUserID"] != null)
                {
                    return (int)ViewState["SelectedUserID"];
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
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);

            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                {
                    SelectedUserID = QueryStringValue;
                    lbUsers.SelectedValue = SelectedUserID.ToString();
                }
                PopulateTools();
            }
        }
        protected void Page_LoadComplete()
        {
            divUserType.Visible = (CookieFunctions.UserTypeID == 3);
            btnBanUser.Visible = (CookieFunctions.UserTypeID == 3);
            aBanUser.Visible = (CookieFunctions.UserTypeID == 3);
        }
        protected void lbUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedUserID = int.Parse(lbUsers.SelectedValue.ToString());
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedUserID > 0)
            {
                divTools.Visible = true;
                sdsCharacters.DataBind();
                DataRow TheUser = DataFunctions.Records.GetUser(SelectedUserID);
                ddlUserType.SelectedValue = TheUser["UserTypeID"].ToString();
                litUserName.Text = TheUser["UserID"].ToString() + " - " + TheUser["Username"].ToString();
                //DateTime StreamLockDateTime;

                //lnkLockStream.Visible = true;
                //btnUnlockStream.Visible = false;

                //if (DateTime.TryParse(TheUser["StreamLockDateTime"].ToString(), out StreamLockDateTime))
                //{
                //    if (StreamLockDateTime <= DateTime.Now.AddMinutes(30))
                //    {
                //        lnkLockStream.Visible = false;
                //        btnUnlockStream.Visible = true;
                //    }
                //}
            }
            else { divTools.Visible = false; }
        }

        protected void lbUsers_DataBound(object sender, EventArgs e)
        {
            lbUsers.SelectedValue = SelectedUserID.ToString();
            PopulateTools();
        }

        protected void ddlUserType_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataFunctions.Updates.UpdateRow("UPDATE Users SET UserTypeID = @ParamTwo WHERE (UserID = @ParamOne)", SelectedUserID, ddlUserType.SelectedValue);
        }

        protected void btnBanUser_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.BanUser(SelectedUserID);
            Response.Redirect("/Admin/Users/");
        }

        protected void btnNewBadge_Click(object sender, EventArgs e)
        {
            DataFunctions.RunStatement("INSERT INTO User_Badges (UserID, BadgeID, ReasonEarned) VALUES (@ParamOne,@ParamTwo,@ParamThree)", SelectedUserID, rblBadges.SelectedValue, txtBadgeReason.Text);
            txtBadgeReason.Text = "";
            rblBadges.ClearSelection();
            rptUserBadges.DataBind();
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "The user has been given the badge selected.";
        }

        protected void rptUserBadges_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveBadge")
            {
                DataFunctions.Deletes.DeleteRows("Delete from User_Badges Where UserBadgeID = @ParamOne", e.CommandArgument);
                rptUserBadges.DataBind();
                pnlMessage.Visible = true;
                pnlMessage.CssClass = "alert alert-success";
                litMessage.Text = "The user's badge has been removed.";
            }

        }

        protected void btnNewNote_Click(object sender, EventArgs e)
        {
            DataFunctions.RunStatement("INSERT INTO User_Notes (UserID, CreatedByUserID, NoteContent) VALUES (@ParamOne,@ParamTwo,@ParamThree)", SelectedUserID, CookieFunctions.UserID, txtNote.Text);
            txtNote.Text = "";
            rptUserNotes.DataBind();
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "The note has been added.";
        }
        //protected void btnLockStream_Click(object sender, EventArgs e)
        //{
        //    DataFunctions.Updates.UpdateRow("Update Users Set StreamLockDateTime = GetDate() Where UserID = @ParamOne", SelectedUserID);
        //    pnlMessage.Visible = true;
        //    pnlMessage.CssClass = "alert alert-success";
        //    litMessage.Text = "The selected user is now locked out of the stream for the next 30 minutes.";
        //    btnUnlockStream.Visible = true;
        //    lnkLockStream.Visible = false;
        //}

        //protected void btnUnlockStream_Click(object sender, EventArgs e)
        //{
        //    DataFunctions.Updates.UpdateRow("Update Users Set StreamLockDateTime = null Where UserID = @ParamOne", SelectedUserID);
        //    pnlMessage.Visible = true;
        //    pnlMessage.CssClass = "alert alert-success";
        //    litMessage.Text = "The selected user is no longer locked from the stream.";
        //    btnUnlockStream.Visible = false;
        //    lnkLockStream.Visible = true;
        //}
    }
}