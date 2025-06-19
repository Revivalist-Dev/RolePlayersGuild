using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates
{
    public partial class Main : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!HttpContext.Current.Request.Url.AbsoluteUri.Contains("localhost"))
            {
                if (!HttpContext.Current.Request.Url.AbsoluteUri.Contains("http://www.roleplayersguild.com")) Response.Redirect("http://www.roleplayersguild.com" + HttpContext.Current.Request.Url.AbsolutePath);
            }
            if (!Page.IsPostBack)
            {
                litOnlineMembers.Text = DataFunctions.Scalars.GetSingleValue("Select Count(UserID) From Users Where LastAction >= DateAdd(hour, -3, GetDate());").ToString();
                litTotalMembers.Text = DataFunctions.Scalars.GetSingleValue("Select Count(UserID) From Users").ToString();
                //litActiveMembers.Text = DataFunctions.Scalars.GetSingleValue("Select Count(UserID) From Users Where LastLogin >= DateAdd(week, -1, GetDate()) OR LastAction >= DateAdd(week, -1, GetDate());").ToString();
                litTotalCharacters.Text = DataFunctions.Scalars.GetSingleValue("Select Count(CharacterID) From Characters").ToString();
                //litActiveCharacters.Text = DataFunctions.Scalars.GetSingleValue("Select Count(CharacterID) From Characters Where UserID In (Select UserID From Users Where LastLogin >= DateAdd(week, -1, GetDate()) OR LastAction >= DateAdd(week, -1, GetDate()));").ToString();
            }

            if (Request.Cookies["UseDarkTheme"] != null)
            {
                litDarkThemeStyleSheet.Visible = bool.Parse(Request.Cookies["UseDarkTheme"].Value);
            }

            if (Request.QueryString["ReferralID"] != null)
            {
                Session["ReferralID"] = Request.QueryString["ReferralID"];
            }


            if (HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Dashboard") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Threads") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Settings") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Characters") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Writing") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("My-Quick-Links") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Testimonials") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("FAQ") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Rules") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("About-Us") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Universe") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Edit") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Chat") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Public") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Search") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Article") ||
                HttpContext.Current.Request.Url.AbsoluteUri.Contains("Art"))
            {
                divAd.InnerHtml = "<script async src=\"//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script> <!-- TopBanner --> <ins class=\"adsbygoogle\" style=\"display:block\" data-ad-client=\"ca-pub-1247828126747788\" data-ad-slot=\"8709602113\" data-ad-format=\"auto\"></ins> <script> (adsbygoogle = window.adsbygoogle || []).push({}); </script>";
            }
            else
            {
                DataRow DisplayedAd = DataFunctions.Records.GetRandomAd(1);
                if (DisplayedAd != null)
                {
                    divAd.InnerHtml = DisplayedAd["AdHTML"].ToString();
                }
            }

            int CurrentUserID = CookieFunctions.UserID;

            if (CurrentUserID != 0)
            {
                if (Session["UserID"] == null) Session["UserID"] = CurrentUserID;
                if (DataFunctions.Scalars.GetMembershipTypeID(CurrentUserID) == 0)
                {
                    Session["HideAds"] = "false";
                }
                else
                {
                    Session["HideAds"] = "true";
                    divAd.Visible = false;
                }


            }
        }
    }
}