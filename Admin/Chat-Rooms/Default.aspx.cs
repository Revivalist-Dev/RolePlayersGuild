using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.ChatRooms
{
    public partial class Default : System.Web.UI.Page
    {
        int SelectedChatRoomID
        {
            get
            {
                if (ViewState["SelectedChatRoomID"] != null)
                {
                    return (int)ViewState["SelectedChatRoomID"];
                }
                return 0;
            }
            set
            {
                ViewState["SelectedChatRoomID"] = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int QueryStringValue;
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out QueryStringValue))
                {
                    SelectedChatRoomID = QueryStringValue;
                    lbChatRooms.SelectedValue = SelectedChatRoomID.ToString();
                }
                PopulateTools();
                ddlUniverses.DataBind();
            }
        }
        protected void Page_LoadComplete()
        {
        }
        protected void lbChatRooms_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedChatRoomID = int.Parse(lbChatRooms.SelectedValue.ToString());
            PopulateTools();
        }
        void PopulateTools()
        {
            if (SelectedChatRoomID > 0)
            {
                divTools.Visible = true;
                sdsChatRooms.DataBind();
                DataRow TheChatRoom = DataFunctions.Records.GetChatRoomWithDetails(SelectedChatRoomID);
                txtChatRoom.Text = TheChatRoom["ChatRoomName"].ToString();
                txtDescription.Text = TheChatRoom["ChatRoomDescription"].ToString();
                chkApproved.Checked = (TheChatRoom["ChatRoomStatusID"].ToString() == "1") ? false : true;
                ddlRating.SelectedValue = TheChatRoom["ContentRatingID"].ToString();
                ddlUniverses.SelectedValue = TheChatRoom["UniverseID"].ToString();
                if (TheChatRoom["UniverseID"].ToString() == "0")
                { lnkUniverse.Visible = false; }
                else
                {
                    lnkUniverse.Visible = true;
                    lnkUniverse.NavigateUrl = "/Universe/?id=" + TheChatRoom["UniverseID"].ToString();
                }
                lnkChatRoom.NavigateUrl = "/Chat-Rooms/Room/?Via=AdminConsole&id=" + SelectedChatRoomID.ToString();
               
                if (TheChatRoom["SubmittedByUserID"].ToString() != "0")
                {
                    lnkSubmittedBy.Visible = true;
                    lnkSubmittedBy.NavigateUrl = "/Admin/Users/?id=" + TheChatRoom["SubmittedByUserID"].ToString();
                    lnkSubmittedBy.Text = "Submitted by: " + TheChatRoom["SubmittedByUserID"] + " - " + TheChatRoom["SubmittedByName"] + " &raquo;";
                }
                else { lnkSubmittedBy.Visible = false; }
            }
            else { divTools.Visible = false; }
        }

        protected void lbChatRooms_DataBound(object sender, EventArgs e)
        {
            if (SelectedChatRoomID > 0) lbChatRooms.SelectedValue = SelectedChatRoomID.ToString();
            PopulateTools();
        }

        protected void btnSaveChatRoom_Click(object sender, EventArgs e)
        {
            DataFunctions.Updates.UpdateRow("UPDATE Chat_Rooms SET ChatRoomName = @ParamTwo, ChatRoomDescription = @ParamThree, ContentRatingID = @ParamFour, ChatRoomStatusID = @ParamFive, UniverseID = @ParamSix WHERE (ChatRoomID = @ParamOne)",
                SelectedChatRoomID, txtChatRoom.Text, txtDescription.Text, ddlRating.SelectedValue, (chkApproved.Checked) ? 2 : 1, ddlUniverses.SelectedValue);

          

            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "The changes have been saved.";
            lbChatRooms.DataBind();
        }
      
        protected void btnDeleteChatRoom_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteChatRoom(SelectedChatRoomID);
            Response.Redirect("/Admin/Chat-Rooms/", false);
        }
        protected void btnPurgeChatRoom_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteRows("Delete From Chat_Room_Posts Where ChatRoomID = @ParamOne", SelectedChatRoomID);
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "The chat room has been purged.";
        }

        protected void btnLockUser_Click(object sender, EventArgs e)
        {
            if (txtUserIDToLock.Text.Length > 0)
            {
                DataFunctions.Inserts.InsertRow("INSERT INTO Chat_Room_Locks (ChatRoomID, UserID) VALUES (@ParamOne,@ParamTwo)", SelectedChatRoomID, txtUserIDToLock.Text);
                rptLockedUsers.DataBind();
                txtUserIDToLock.Text = "";
            }
        }

        protected void rptLockedUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "UnlockUser")
            {
                DataFunctions.Deletes.DeleteRows("Delete from Chat_Room_Locks Where ChatRoomID = @ParamOne and UserID = @ParamTwo", SelectedChatRoomID, e.CommandArgument);
                rptLockedUsers.DataBind();
            }
        }
    }
}