using System;
using System.Web.UI;

namespace RolePlayersGuild.templates.controls
{
    public partial class VotePrompt : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //var currentUserId = CookieFunctions.UserID;
            //if (currentUserId == 0) return;
            //var lastVoteDateTime = DataFunctions.Scalars.GetSingleValue("Select LastVoteDateTime From Users Where UserID = @ParamOne", currentUserId);

            //if (lastVoteDateTime.ToString() == "" || DateTime.Now.AddHours(-25) > (DateTime)lastVoteDateTime)
            //{ pnlVotingPrompt.Visible = true; }
        }
    }
}