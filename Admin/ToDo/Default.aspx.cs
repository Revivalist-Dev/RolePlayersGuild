using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin.ToDo
{
    public partial class Default : System.Web.UI.Page
    {
        protected void BindToDoItems()
        {
            sdsToDoItems.SelectCommand = "SELECT CreatedDateTime, ItemID, ItemName, TypeName, StatusName, AssignedToUsername, CreatedByUsername, VoteCount, TypeID, StatusID, AssignedToUserID, CreatedByUserID, ItemDescription FROM ToDoItemsWithDetails WHERE 0=0";
            if (ddlAssignedToFilter.SelectedValue != "0")
            { sdsToDoItems.SelectCommand += " AND AssignedToUserID = @AssignedToUserID"; }
            if (ddlStatusFilter.SelectedValue != "0")
            { sdsToDoItems.SelectCommand += " AND StatusID = @StatusID"; }
            else { sdsToDoItems.SelectCommand += " AND (StatusID <> 3 AND StatusID <> 2)"; }
            if (ddlTypesFilter.SelectedValue != "0")
            { sdsToDoItems.SelectCommand += " AND TypeID = @TypeID"; }
            sdsToDoItems.SelectCommand += " Order By ItemID DESC";

            gvToDoItems.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindToDoItems();
        }

        protected void gvToDoItems_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            BindToDoItems();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            if (!Page.IsPostBack)
            { BindToDoItems(); }
        }
    }
}