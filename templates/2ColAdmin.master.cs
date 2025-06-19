using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates
{
    public partial class _2ColAdmin : MasterPage
    {
        public Panel PnlRightCol { get { return pnlRightCol; } }
        public Panel PnlLeftCol { get { return pnlLeftCol; } }

        protected void Page_Init()
        {
            int UserID = CookieFunctions.UserID;
            if (UserID == 0)
            {
                Response.Redirect("/");
            }

            DataRow SelectedUser = DataFunctions.Records.GetUser(UserID);

            if (SelectedUser["UserTypeID"].ToString() == "2" ||
               SelectedUser["UserTypeID"].ToString() == "3" ||
               SelectedUser["UserTypeID"].ToString() == "4")
            {
                CookieFunctions.IsStaff = true;
                CookieFunctions.UserTypeID = (int)SelectedUser["UserTypeID"];
            }
            else
            {
                CookieFunctions.IsStaff = false;
                Response.Redirect("/logout/");
            }

            //if (!CookieFunctions.IsStaff)
            //{
            //    Response.Redirect("/");
            //}
            DataFunctions.Updates.UpdateRow("UPDATE Users SET LastAction = GetDate() WHERE UserID = @ParamOne;", UserID);


        }
    }
}