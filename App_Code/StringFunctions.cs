using System;
using System.Configuration;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;

namespace RolePlayersGuild
{
    public class StringFunctions
    {

        public static string TextEncrypt(string clearText)
        {
            string EncryptionKey = ConfigurationManager.AppSettings["EncryptionKey"];
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);

            using (Rijndael encryptor = Rijndael.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream MS = new MemoryStream())
                {
                    using (CryptoStream CS = new CryptoStream(MS, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        CS.Write(clearBytes, 0, clearBytes.Length);
                        CS.Close();
                    }
                    clearText = Convert.ToBase64String(MS.ToArray());
                }
            }
            return HttpUtility.UrlEncode(clearText);
        }


        public static string TextDecrypt(string encryptedText)
        {
            string EncryptionKey = ConfigurationManager.AppSettings["EncryptionKey"];
            string DecodedCipher = HttpUtility.UrlDecode(encryptedText);
            byte[] CipherBytes = Convert.FromBase64String(DecodedCipher);

            using (Rijndael encryptor = Rijndael.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });

                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(CipherBytes, 0, CipherBytes.Length);
                        cs.Close();
                    }
                    DecodedCipher = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return DecodedCipher;
        }
        
        public static string Protect(string text, string purpose)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            byte[] stream = Encoding.UTF8.GetBytes(text);
            byte[] encodedValue = MachineKey.Protect(stream, purpose);
            return HttpServerUtility.UrlTokenEncode(encodedValue);
        }

        public static string Unprotect(string text, string purpose)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            byte[] stream = HttpServerUtility.UrlTokenDecode(text);
            byte[] decodedValue = MachineKey.Unprotect(stream, purpose);
            return Encoding.UTF8.GetString(decodedValue);
        }
        public static string DisplayImageString(string imageString, string size, bool IsMature = false)
        {
            if (IsMature) { return ConfigurationManager.AppSettings["DisplayCharacterImagesFolder"].ToString() + "AdultsOnly.jpg"; }
            else {
                if (imageString.Length > 0)
                { return ConfigurationManager.AppSettings["DisplayCharacterImagesFolder"].ToString() + size + "img_" + imageString; }
                else
                { return ConfigurationManager.AppSettings["DisplayCharacterImagesFolder"].ToString() + "NewCharacter.png"; }
            }
        }
        public static string GenerateRandomString(int StringLength, string AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ1234567890")
        {
            Random rdm = new Random();
            char[] allowChrs = AllowedCharacters.ToCharArray();
            string sResult = "";

            for (int i = 0; i <= StringLength - 1; i++)
            {
                sResult += allowChrs[rdm.Next(0, allowChrs.Length)];
            }

            return sResult;
        }
        public static string ShowTimeAgo(string DateTimeString)
        {
            DateTime TimeStart;

            if (DateTime.TryParse(DateTimeString, out TimeStart))
            {
                DateTime CurrentDateTime = DateTime.Now;

                TimeSpan TimeBetweenDates = CurrentDateTime - TimeStart;

                if (TimeBetweenDates.TotalSeconds < 60)
                {
                    if (TimeBetweenDates.Seconds < 2)
                    {
                        return "Just Now";
                    }
                    return TimeBetweenDates.Seconds.ToString() + " Seconds Ago";
                }
                else if (TimeBetweenDates.TotalMinutes < 60)
                {
                    if (TimeBetweenDates.Minutes == 1)
                    {
                        return TimeBetweenDates.Minutes.ToString() + " Minute Ago";
                    }
                    return TimeBetweenDates.Minutes.ToString() + " Minutes Ago";
                }
                else if (TimeBetweenDates.TotalHours < 24)
                {
                    if (TimeBetweenDates.Hours == 1)
                    {
                        return TimeBetweenDates.Hours.ToString() + " Hour Ago";
                    }
                    return "About " + TimeBetweenDates.Hours.ToString() + " Hours Ago";
                }
                else if (TimeBetweenDates.TotalDays < 7)
                {
                    if (TimeBetweenDates.Days == 1)
                    {
                        return TimeBetweenDates.Days.ToString() + " Day Ago";
                    }
                    return TimeBetweenDates.Days.ToString() + " Days Ago";
                }
                else
                {
                    return TimeStart.ToString("MMM dd, yyyy");
                }

            }

            return "Invalid Date";
        }
    }
}