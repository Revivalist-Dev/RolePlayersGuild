using System;
using System.Data;

namespace RolePlayersGuild.Admin.StreamSettings
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("/Admin/Chat-Rooms/");
            if (!Page.IsPostBack)
            {
                string SettingDesc = DataFunctions.Scalars.GetSingleValue("Select StreamSettingDescription From General_Settings").ToString();
                txtSettingInfo.Text = SettingDesc;
            }
        }

        protected void btnSaveSetting_Click(object sender, EventArgs e)
        {
            DataFunctions.Updates.UpdateRow("UPDATE General_Settings SET StreamSettingDescription = @ParamOne", txtSettingInfo.Text);
            DataFunctions.Inserts.InsertRow("INSERT INTO UpdateStream (StreamPostContent, StreamPostMadeByCharacterID) VALUES (@ParamOne,@ParamTwo)", "<div class='alert alert-ooc'>The setting in the stream has been changed! Please click on \"Where are we today?\" for more information about the new setting. Any Role-Plays still going on in the old setting should now be moved to their own threads to avoid cross-setting confusion. Enjoy!</div>", 1450);
        }
    }
}