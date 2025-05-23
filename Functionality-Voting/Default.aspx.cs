using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.FunctionalityVoting
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
        }
        //protected string ShowVotesOrButton(object VoteCount, object ItemID)
        //{
        //    int CountOfUserVotesOnItem = int.Parse(DataFunctions.Scalars.GetSingleValue("Select Count(ToDoItemVoteID) From ToDo_Item_Votes Where ToDoItemID = @ParamOne And UserID = @ParamTwo", ItemID, Session["UserID"]).ToString());

        //    if (CountOfUserVotesOnItem == 0)
        //    { return VoteCount.ToString() + " Votes<br/><a class=\"btn btn-success\" href='/Functionality-Voting/Vote?id=" + ItemID.ToString() + "'><span class=\"glyphicon glyphicon-plus\"></span>&nbsp;Vote</a>"; }
        //    else
        //    { return VoteCount.ToString() + " Votes<br/><a class=\"btn btn-danger\" href='/Functionality-Voting/Vote?id=" + ItemID.ToString() + "' title='You have already voted on this idea clicking this will cancel your vote.'>Remove Vote</a>"; }

        //}
        protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            litMessage.Text = "Your idea has been submitted. Please take a moment to look through the others and cast your votes for ideas you like!";
        }

        protected void rptToDoItems_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;

                LinkButton btnAddVote = (LinkButton)(e.Item.FindControl("btnAddVote"));
                LinkButton btnRemoveVote = (LinkButton)(e.Item.FindControl("btnRemoveVote"));
                int CountOfUserVotesOnItem = int.Parse(DataFunctions.Scalars.GetSingleValue("Select Count(ToDoItemVoteID) From ToDo_Item_Votes Where ToDoItemID = @ParamOne And UserID = @ParamTwo", drv["ItemID"], Session["UserID"]).ToString());

                if (CountOfUserVotesOnItem == 0)
                { btnAddVote.Visible = true; }
                else { btnRemoveVote.Visible = true; }
            }
        }

        protected void rptToDoItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int ItemID = int.Parse(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "AddVote":
                    int CountOfUserVotesOnItem = int.Parse(DataFunctions.Scalars.GetSingleValue("Select Count(ToDoItemVoteID) From ToDo_Item_Votes Where ToDoItemID = @ParamOne And UserID = @ParamTwo", ItemID, Session["UserID"]).ToString());
                    if (CountOfUserVotesOnItem == 0)
                    { DataFunctions.Inserts.InsertRow("INSERT INTO ToDo_Item_Votes (ToDoItemID, UserID) VALUES (@ParamOne,@ParamTwo)", ItemID, Session["UserID"]); }
                    break;
                case "RemoveVote":
                    DataFunctions.Deletes.DeleteRows("DELETE FROM ToDo_Item_Votes WHERE (ToDoItemID = @ParamOne) AND (UserID = @ParamTwo)", ItemID, Session["UserID"]);
                    break;
            }
            rptToDoItems.DataBind();
        }
    }
}