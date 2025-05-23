using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates
{
    public partial class _2_Col_With_Authentication : MasterPage
    {
        public Panel PnlRightCol { get { return pnlRightCol; } }
        public Panel PnlLeftCol { get { return pnlLeftCol; } }

        protected void Page_Init(object sender, EventArgs e)
        {
            int CurrentUserID = CookieFunctions.UserID;

            if (CurrentUserID == 0)
            {
                Response.Redirect("/Register/?rsn=NoAccess");
            }
            else {
                DataRow UserRecord = DataFunctions.Records.GetDataRow("Select * From Users where UserID = @ParamOne", 0, CurrentUserID);

                if (UserRecord == null)
                { Response.Redirect("/Logout/"); }

                if (DateTime.Now.Month == 10 && DateTime.Now.Day == 31)
                {
                    DataFunctions.AwardBadgeIfNotExisting(21, CurrentUserID);
                }
                if (DateTime.Now.Month == 11 && DateTime.Now.DayOfWeek == DayOfWeek.Thursday && DateTime.Now.Month != DateTime.Now.AddDays(7).Month)
                {
                    DataFunctions.AwardBadgeIfNotExisting(22, CurrentUserID);
                }
                if (DateTime.Now.Month == 12)
                {
                    DataFunctions.AwardBadgeIfNotExisting(23, CurrentUserID);
                }

                DateTime joinedDate = DateTime.Parse(UserRecord["MemberJoinedDate"].ToString()).Date;

                if (DateTime.Now.Month >= joinedDate.Month && DateTime.Now.Day >= joinedDate.Day && DateTime.Now.Year > joinedDate.Year)
                {
                    DataFunctions.AwardBadgeIfNotExisting(25, CurrentUserID);
                    if (DateTime.Now.Year > joinedDate.Year + 1)
                    {
                        DataFunctions.AwardBadgeIfNotExisting(32, CurrentUserID);
                        if (DateTime.Now.Year > joinedDate.Year + 2)
                        {
                            DataFunctions.AwardBadgeIfNotExisting(33, CurrentUserID);
                        }
                    }
                }

                DataFunctions.Updates.UpdateRow("UPDATE Users SET LastAction = GetDate() WHERE UserID = @ParamOne;", CurrentUserID);
                if (Session["UserID"] == null) Session["UserID"] = CurrentUserID;
            }
            int CharacterCount = DataFunctions.Scalars.GetCharacterCount(CurrentUserID);
            if (CharacterCount < 1 && !HttpContext.Current.Request.Url.AbsoluteUri.Contains("/My-Characters/Edit-Character/"))
            {
                Session["HasCharacters"] = null;
                Response.Redirect("/My-Characters/Edit-Character/?Mode=New&Via=NewMember");
            }
            else if (CharacterCount > 0) { Session["HasCharacters"] = "true"; }
        }
    }
}