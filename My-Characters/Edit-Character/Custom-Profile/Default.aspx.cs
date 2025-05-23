using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.MyCharacters.EditCharacter.CustomProfile
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Init()
        {


        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["CharID"] != null)
                {

                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                    con.Open();
                    //SqlDataAdapter sda = new SqlDataAdapter();
                    //SqlCommand scGetCharacter = new SqlCommand("Select [CustomProfileEnabled] From Characters Where CharacterID = @CharID;");
                    //scGetCharacter.Parameters.AddWithValue("CharID", Request.QueryString["CharID"]);
                    //bool CustomProfileEnabled = scGetCharacter.ExecuteScalar();

                    SqlCommand scGetProfile = new SqlCommand("Select ProfileCSS, ProfileHTML, CustomProfileEnabled From Characters Where CharacterID = @CharID;", con);
                    scGetProfile.Parameters.AddWithValue("CharID", Request.QueryString["CharID"]);
                    SqlDataReader sdrProfiles = scGetProfile.ExecuteReader();
                    if (sdrProfiles.HasRows)
                    {
                        sdrProfiles.Read();
                        txtProfileCSS.Text = sdrProfiles["ProfileCSS"].ToString();
                        txtProfileHTML.Text = sdrProfiles["ProfileHTML"].ToString();
                        chkEnableCustomProfile.Checked = bool.Parse(sdrProfiles["CustomProfileEnabled"].ToString());
                    }
                    //else
                    //{
                    //    SqlCommand scCreateProfile = new SqlCommand("")
                    //}
                    con.Close();
                }
                else
                {
                    Response.Redirect("/My-Characters/", true);
                }
            }
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            //if (chkEnableCustomProfile.Checked)
            //{
            //    if (txtProfileCSS.Text.Length > 0 && txtProfileHTML.Text.Length > 0)
            //    {

            //    }
            //    else
            //    {
            //        pnlMessage.CssClass = "alert alert-danger";
            //        pnlMessage.Visible = false;
            //        litMessage.Text = "It seems your CSS or HTML are completely empty. This could lead to undesired results. Place make sure that both boxes have something, even if it's a comment.";
            //    }
            //}

            if (txtProfileCSS.Text.ToUpper().Contains("</STYLE>") ||
                txtProfileCSS.Text.ToUpper().Contains("<SCRIPT>") ||
                txtProfileCSS.Text.ToUpper().Contains("</SCRIPT>") ||
                txtProfileHTML.Text.ToUpper().Contains("<SCRIPT>") ||
                txtProfileHTML.Text.ToUpper().Contains("</SCRIPT>") ||
                txtProfileCSS.Text.ToUpper().Contains("<META") ||
                txtProfileHTML.Text.ToUpper().Contains("<META>"))
            {
                pnlMessage.CssClass = "alert alert-danger";
                pnlMessage.Visible = true;
                litMessage.Text = "We're sorry, but it seems that some of your code may have a tag that could be harmful to the user experience on the website. This may include one of the following tags: Script/Meta/Style. If you are trying to do something with one of the Meta or Script tags, please find an alternative method to accomplish what you need. If this error is because of a Script tag, please remember that those are not necessary and that your CSS code should simply be typed in as plain content into the CSS textbox. If you have further questions, please message <a href=\"/Character/id?=20\" target=\"_blank\">RPG Admin</a>.";

            }
            else {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                con.Open();
                SqlCommand scUpdateProfile = new SqlCommand("UPDATE Characters SET ProfileCSS = @CSS, ProfileHTML = @HTML, CustomProfileEnabled = @Enabled WHERE (CharacterID = @CharID);", con);
                scUpdateProfile.Parameters.AddWithValue("CharID", Request.QueryString["CharID"]);
                scUpdateProfile.Parameters.AddWithValue("CSS", txtProfileCSS.Text);
                scUpdateProfile.Parameters.AddWithValue("HTML", txtProfileHTML.Text);
                scUpdateProfile.Parameters.AddWithValue("Enabled", chkEnableCustomProfile.Checked);
                scUpdateProfile.ExecuteNonQuery();
                con.Close();
                pnlMessage.CssClass = "alert alert-success";
                pnlMessage.Visible = true;
                litMessage.Text = "Your changes have been saved!";
            }
        }
    }
}