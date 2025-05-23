using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Admin
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //2 = Mod
            //3 = Admin
            //4 = LT Mod
            //5 = Officer
            liCharactersUnderReviewListing.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liCharacterListing.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liUserListing.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liUniverses.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liArticles.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liToDoItems.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liMassMessage.Visible = (CookieFunctions.UserTypeID == 3);
            liChatRooms.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liStories.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            liSiteRules.Visible = (CookieFunctions.UserTypeID == 3);
            liSitePurge.Visible = (CookieFunctions.UserID == 2);
            liSitePrivacyPolicy.Visible = (CookieFunctions.UserTypeID == 3);
            liSiteFundingGoals.Visible = (CookieFunctions.UserTypeID == 3);
            //liStreamArchive.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2 || CookieFunctions.UserTypeID == 4);
            //liStreamSettings.Visible = (CookieFunctions.UserTypeID == 3 || CookieFunctions.UserTypeID == 2);
        }
    }
}