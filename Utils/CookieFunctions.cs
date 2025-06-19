using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RolePlayersGuild
{
    public class CookieFunctions
    {
        public static void SetEncryptedCookie(string name, string value, string purpose = "General Cookie Encryption")
        {
            var encryptName = StringFunctions.TextEncrypt(name);
            HttpContext.Current.Response.Cookies[encryptName].Value = StringFunctions.Protect(value, purpose);
            HttpContext.Current.Response.Cookies[encryptName].Expires = DateTime.Now.AddDays(2);
        }
        public static void RemoveEncryptedCookie(string name, string purpose = "General Cookie Encryption")
        {
            var encryptName = StringFunctions.TextEncrypt(name);
            HttpContext.Current.Response.Cookies[encryptName].Expires = DateTime.Now.AddDays(-1);
        }
        public static string GetEncryptedCookie(string name, string purpose = "General Cookie Encryption")
        {
            var encryptName = StringFunctions.TextEncrypt(name);
            if (HttpContext.Current.Request.Cookies[encryptName] != null)
            {
                return StringFunctions.Unprotect(HttpContext.Current.Request.Cookies[encryptName].Value, purpose);
            }
            else { return ""; }
        }

        public static void RefreshCookies()
        {
            UserID = UserID;
            UserTypeID = UserTypeID;
            HideStream = HideStream;
            IsStaff = IsStaff;
        }

        public static int UserID
        {
            get
            {
                int myUserID = 0;
                if (int.TryParse(GetEncryptedCookie("UserID"), out myUserID)) return myUserID;
                return 0;
            }
            set { SetEncryptedCookie("UserID", value.ToString()); }


        }
        public static int MembershipTypeID
        {
            get
            {
                int myUserID = 0;
                if (int.TryParse(GetEncryptedCookie("MembershipTypeID"), out myUserID)) return myUserID;
                return 0;
            }
            set { SetEncryptedCookie("MembershipTypeID", value.ToString()); }


        }
        public static int UserTypeID
        {
            get
            {
                int myUserID = 0;
                if (int.TryParse(GetEncryptedCookie("UserTypeID"), out myUserID)) return myUserID;
                return 0;
            }
            set { SetEncryptedCookie("UserTypeID", value.ToString()); }
        }
        public static bool IsStaff
        {
            get
            {
                bool myIsStaffBool = false;
                if (bool.TryParse(GetEncryptedCookie("IsStaff"), out myIsStaffBool)) return myIsStaffBool;
                return false;
            }
            set { SetEncryptedCookie("IsStaff", value.ToString()); }
        }
        public static bool HideStream
        {
            get
            {
                bool HideStreamBool = false;
                if (bool.TryParse(GetEncryptedCookie("HideStream"), out HideStreamBool)) return HideStreamBool;
                return false;
            }
            set { SetEncryptedCookie("HideStream", value.ToString()); }
        }
    }
}