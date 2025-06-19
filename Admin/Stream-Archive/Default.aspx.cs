using System;
using System.Data;

namespace RolePlayersGuild.Admin.StreamArchive
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("/Admin/Chat-Rooms/");
        }
        protected string StaffClass(object IsStaff)
        {

            if ((bool)IsStaff)
            {
                return "StaffLink";
            }
            return "";
        }

        protected void btnPurgeStream_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteRows("Delete from UpdateStream Where StreamPostID < (Select Max(StreamPostID) - 10 from UpdateStream)", "");
        }
    }
}