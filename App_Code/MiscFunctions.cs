using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace RolePlayersGuild
{
    public class MiscFunctions
    {
        public static void MarkCharacterForReview(int CharacterID)
        {
            int OwnerUserID = DataFunctions.Scalars.GetUserID(CharacterID);
            DataFunctions.RunStatement("Update Characters Set CharacterStatusID = 2 Where CharacterID = @ParamOne", CharacterID);
            int ThreadID = DataFunctions.Inserts.CreateNewThread("[RPG] - Character Locked");

            DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-danger\"><p>This character been locked and placed under review as it has violated the rules of the Role-Players Guild. Please take a moment to review the rules of the website. Once you have made changes to ensure that this character no longer violates the rules of the website, please feel free to <a href=\"/Report/\">Submit a Report</a> to have your character reviewed and unlocked.</p><p>Please note that characters that have not been fixed within 30 days will be deleted.</p></div>");

            DataFunctions.Inserts.InsertThreadUser(OwnerUserID, ThreadID, 2, CharacterID, 1);
            DataFunctions.RunStatement("INSERT INTO User_Notes (UserID, CreatedByUserID, NoteContent) VALUES (@ParamOne,@ParamTwo,@ParamThree)", OwnerUserID, CookieFunctions.UserID, "AUTOMATED NOTE: Character " + CharacterID.ToString() + " was locked out and marked for review.");
            HttpContext.Current.Response.Redirect("/Admin/Characters-Under-Review/?id=" + CharacterID);
        }
        public static string CurrentIP
        {
            get
            {
                string VisitorsIPAddr = string.Empty;
                if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                {
                    VisitorsIPAddr = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                }
                else if (HttpContext.Current.Request.UserHostAddress.Length != 0)
                {
                    VisitorsIPAddr = HttpContext.Current.Request.UserHostAddress;
                }
                return VisitorsIPAddr;
            }
        }
        public static bool IsInternalReferrer
        {
            get
            {
                return (HttpContext.Current.Request.UrlReferrer.ToString().Contains("http://www.roleplayersguild.com") || HttpContext.Current.Request.UrlReferrer.ToString().Contains("localhost"));                
            }
        }
        public static void SetUserInfo(DataRow SelectedUser)
        {

            int UserID = (int)SelectedUser["UserID"];

            DataFunctions.RunStatement("INSERT INTO Login_Attempts (AttemptedUsername, AttemptedPassword, IPAddress, AttemptWasSuccessful) VALUES (@ParamOne,@ParamTwo,@ParamThree,@ParamFour); UPDATE Users SET LastLogin = GETDATE() WHERE (UserID = @ParamFive);", SelectedUser["EmailAddress"].ToString(), "--", CurrentIP, true, UserID);            

            CookieFunctions.UserID = UserID;
            CookieFunctions.UserTypeID = (int)SelectedUser["UserTypeID"];
            CookieFunctions.HideStream = (bool)SelectedUser["HideStream"];
            CookieFunctions.MembershipTypeID = DataFunctions.Scalars.GetMembershipTypeID(CookieFunctions.UserID);


            HttpContext.Current.Response.Cookies["UseDarkTheme"].Value = SelectedUser["UseDarkTheme"].ToString();
            HttpContext.Current.Response.Cookies["UseDarkTheme"].Expires = DateTime.Now.AddDays(14);

            if (SelectedUser["UserTypeID"].ToString() == "2" || 
                SelectedUser["UserTypeID"].ToString() == "3" ||
                SelectedUser["UserTypeID"].ToString() == "4")
            {
                CookieFunctions.IsStaff = true;
            }
            else
            {
                CookieFunctions.IsStaff = false;
            }

        }
    }
}