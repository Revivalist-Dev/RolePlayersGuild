using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Drawing;

namespace RolePlayersGuild.templates.controls
{
    public partial class ThreadListing : System.Web.UI.UserControl
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 10;
        public string OnlineStatus(object LastAction, object ShowWhenOnline)
        {
            DateTime dtLastAction;
            if (LastAction != null && DateTime.TryParse(LastAction.ToString(), out dtLastAction) &&
                dtLastAction > DateTime.Now.AddHours(-3) &&
                (bool)ShowWhenOnline)
            {
                //var intTypeID = 0;
                //if (int.TryParse(TypeID.ToString(), out intTypeID) && intTypeID == 2)
                //{ return "Online staff"; }
                return "Online";
            }
            return "Offline";
        }
        public string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
        }

        private int CurrentUserID
        {
            get
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("/");
                    return 0;
                }
                return ((int)Session["UserID"]);
            }
        }

        private int CurrentPage
        {
            get
            {
                if (Request.QueryString["pg"] == null || Request.QueryString["pg"].ToString().Length == 0)
                {
                    return 1;
                }
                return (int.Parse(Request.QueryString["pg"].ToString()));
            }
            set
            {
                Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?pg=" + value.ToString());
            }
        }
        public string ListType { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                litFolderName.Text = ListType;
                pnlThreadListing.Visible = true;
                switch (ListType)
                {
                    case "Active Threads":
                    case "Unanswered Threads":
                    case "Unread Threads":
                    case "Answered Threads":
                    case "Abandoned Threads":
                        break;
                    default:
                        pnlThreadListing.Visible = false;
                        litFolderName.Text = "Selected folder is not supported.";
                        break;
                }

                BindDataIntoRepeater();
            }
        }

        // Get data from database/repository
        DataTable GetDataFromDb(bool OnlyUnread)
        {
            switch (ListType)
            {
                case "Active Threads":
                    return DataFunctions.Tables.GetDataTable("Select Distinct ThreadTitle, ThreadID, LastUpdateDate, ReadStatus, ReadStatusID From RecentUserThreads Where UserID = @ParamOne And TypeID = 1 Order By LastUpdateDate DESC", CurrentUserID);
                case "Unanswered Threads":
                    return DataFunctions.Tables.GetDataTable("Select Distinct ThreadTitle, ThreadID, LastUpdateDate, ReadStatus, ReadStatusID From CurrentUserThreadsWithDetails Where UserID = @ParamOne And TypeID = 1 AND LastPostByUserID <> @ParamOne Order By LastUpdateDate DESC", CurrentUserID);
                case "Unread Threads":
                    return DataFunctions.Tables.GetDataTable("Select Distinct ThreadTitle, ThreadID, LastUpdateDate, ReadStatus, ReadStatusID From RecentUserThreads Where UserID = @ParamOne And TypeID = 1 AND ReadStatusID = 2 Order By LastUpdateDate DESC", CurrentUserID);
                case "Answered Threads":
                    return DataFunctions.Tables.GetDataTable("Select Distinct ThreadTitle, ThreadID, LastUpdateDate, ReadStatus, ReadStatusID From CurrentUserThreadsWithDetails Where UserID = @ParamOne And TypeID = 1 AND LastPostByUserID = @ParamOne Order By LastUpdateDate DESC", CurrentUserID);
                case "Abandoned Threads":
                    return DataFunctions.Tables.GetDataTable("Select Distinct ThreadTitle, ThreadID, LastUpdateDate, ReadStatus, ReadStatusID From CurrentUserThreadsWithDetails Where ThreadID IN (SELECT ThreadID FROM Thread_Users GROUP BY ThreadID Having COUNT(UserID) = 1) AND UserID = @ParamOne And TypeID = 1 Order By LastUpdateDate DESC", CurrentUserID);
            }
            return null;
        }
        // Bind PagedDataSource into Repeater
        private void BindDataIntoRepeater()
        {
            bool OnlyUnread = false;

            if (ViewState["ViewUndreadMessages"] != null)
            { OnlyUnread = bool.Parse(ViewState["ViewUndreadMessages"].ToString()); }

            var dt = GetDataFromDb(OnlyUnread);
            _pgsource.DataSource = dt.DefaultView;
            _pgsource.AllowPaging = true;
            // Number of items to be displayed in the Repeater
            _pgsource.PageSize = _pageSize;
            _pgsource.CurrentPageIndex = CurrentPage - 1;
            // Keep the Total pages in View State
            ViewState["TotalPages"] = _pgsource.PageCount;
            // Example: "Page 1 of 10"
            //lblpage.Text = "Page " + (CurrentPage + 1) + " of " + _pgsource.PageCount;
            // Enable First, Last, Previous, Next buttons
            //lbPrevious.Enabled = !_pgsource.IsFirstPage;
            //lbNext.Enabled = !_pgsource.IsLastPage;
            lbFirst.Enabled = !_pgsource.IsFirstPage;
            lbLast.Enabled = !_pgsource.IsLastPage;

            // Bind data into repeater
            rptThreadListing.DataSource = _pgsource;
            rptThreadListing.DataBind();

            // Call the function to do paging
            HandlePaging();
        }
        private void HandlePaging()
        {
            var dt = new DataTable();
            dt.Columns.Add("PageIndex"); //Start from 1
            dt.Columns.Add("PageText"); //Start from 1

            _firstIndex = CurrentPage - 2;
            if (CurrentPage > 2)
                _lastIndex = CurrentPage + 3;
            else
                _lastIndex = 5;

            // Check last page is greater than total page then reduced it 
            // to total no. of page is last index
            if (_lastIndex > Convert.ToInt32(ViewState["TotalPages"]))
            {
                _lastIndex = Convert.ToInt32(ViewState["TotalPages"]);
                _firstIndex = _lastIndex - 5;
            }

            if (_firstIndex < 0)
                _firstIndex = 0;

            //Now creating page number based on above first and last page index
            for (var i = _firstIndex; i < _lastIndex; i++)
            {
                var dr = dt.NewRow();
                dr[0] = i + 1;
                dr[1] = i + 1;
                dt.Rows.Add(dr);
            }

            rptPaging.DataSource = dt;
            rptPaging.DataBind();
        }
        protected void lbFirst_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
        }
        protected void lbLast_Click(object sender, EventArgs e)
        {
            CurrentPage = Convert.ToInt32(ViewState["TotalPages"]);
        }
        //protected void lbPrevious_Click(object sender, EventArgs e)
        //{
        //    //CurrentPage -= 1;
        //    //BindDataIntoRepeater();
        //}
        //protected void lbNext_Click(object sender, EventArgs e)
        //{
        //    //CurrentPage += 1;
        //    //BindDataIntoRepeater();
        //}
        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!e.CommandName.Equals("newPage")) return;
            CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
            BindDataIntoRepeater();
        }
        protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
            if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
            lnkPage.Enabled = false;
            lnkPage.CssClass = "CurrentPage";
        }

        protected void rptThreadListing_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                int ThreadID = int.Parse(drv.Row["ThreadID"].ToString());
                string ReadStatus = drv.Row["ReadStatus"].ToString();

                ScriptManager scriptMan = ScriptManager.GetCurrent(this.Page);

                Repeater rptCharacters = (Repeater)(e.Item.FindControl("rptCharacters"));
                Panel pnlThread = (Panel)(e.Item.FindControl("pnlThread"));
                Literal litReadStatus = (Literal)(e.Item.FindControl("litReadStatus"));
                //HtmlGenericControl liMarkUnread = (HtmlGenericControl)(e.Item.FindControl("liMarkUnread"));
                //HtmlGenericControl liMarkRead = (HtmlGenericControl)(e.Item.FindControl("liMarkRead"));
                //LinkButton btnMarkUnread = (LinkButton)(e.Item.FindControl("btnMarkUnread"));
                //LinkButton btnMarkRead = (LinkButton)(e.Item.FindControl("btnMarkRead"));
                HiddenField hdnThreadID = (HiddenField)(e.Item.FindControl("hdnThreadID"));

                //btnMarkUnread.CommandArgument = ThreadID.ToString();
                //btnMarkRead.CommandArgument = ThreadID.ToString();

                //scriptMan.RegisterAsyncPostBackControl(btnMarkUnread);
                //scriptMan.RegisterAsyncPostBackControl(btnMarkRead);

                //if (ReadStatus == "Read") { liMarkUnread.Visible = true; } else { liMarkRead.Visible = true; }
                pnlThread.CssClass = "Thread " + ReadStatus;
                litReadStatus.Text = ReadStatus;

                hdnThreadID.Value = ThreadID.ToString();

                sdsCharacters.SelectParameters[0].DefaultValue = ThreadID.ToString();
                rptCharacters.DataSource = sdsCharacters;
                rptCharacters.DataBind();
            }
        }

        protected void rptThreadListing_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int ThreadID = int.Parse(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "MarkUnread":
                    DataFunctions.Updates.ChangeReadStatusForCurrentUser(ThreadID, 2);
                    break;
                case "MarkRead":
                    DataFunctions.Updates.ChangeReadStatusForCurrentUser(ThreadID, 1);
                    break;
            }
            BindDataIntoRepeater();
        }

        protected void rptThreadListing_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
               
            }
        }

        protected void btnDeleteSelectedThreads_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem thread in rptThreadListing.Items)
            {
                CheckBox chkSelectThread = (CheckBox)(thread.FindControl("chkSelectThread"));
                HiddenField hdnThreadID = (HiddenField)(thread.FindControl("hdnThreadID"));
                if (chkSelectThread.Checked)
                {
                    int ThreadID = int.Parse(hdnThreadID.Value);
                    DataFunctions.Deletes.RemoveThreadUser(CookieFunctions.UserID, ThreadID);
                    DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-danger\">A writer has left this thread.</div>");
                }
            }
            BindDataIntoRepeater();
        }

        protected void btnMarkAsUnread_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem thread in rptThreadListing.Items)
            {
                CheckBox chkSelectThread = (CheckBox)(thread.FindControl("chkSelectThread"));
                HiddenField hdnThreadID = (HiddenField)(thread.FindControl("hdnThreadID"));
                if (chkSelectThread.Checked)
                {
                    DataFunctions.Updates.ChangeReadStatusForCurrentUser(int.Parse(hdnThreadID.Value), 2);
                }
            }
            BindDataIntoRepeater();
        }

        //protected void btnViewUnread_Click(object sender, EventArgs e)
        //{
        //    if (btnViewUnread.Text.Contains("Unread"))
        //    {
        //        ViewState["ViewUndreadMessages"] = true;
        //        CurrentPage = 0;
        //        BindDataIntoRepeater();
        //        btnViewUnread.Text = "View All";
        //    }
        //    else {
        //        ViewState["ViewUndreadMessages"] = false;
        //        CurrentPage = 0;
        //        BindDataIntoRepeater();
        //        btnViewUnread.Text = "View Only Unread";
        //    }
        //}

        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }
    }
}