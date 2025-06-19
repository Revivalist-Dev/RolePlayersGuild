using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.Story.Posts
{
    public partial class Default : System.Web.UI.Page
    {
        readonly PagedDataSource _pgsource = new PagedDataSource();
        int _firstIndex, _lastIndex;
        private int _pageSize = 10;
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
                Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?storyid=" + Request.QueryString["storyid"].ToString() + "&pg=" + value.ToString());
            }
        }
        private int StoryID
        {
            get
            {
                if (ViewState["StoryID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["StoryID"]);
            }
            set { ViewState["StoryID"] = value; }
        }

        private int OwnerUserID
        {
            get
            {
                if (ViewState["OwnerUserID"] == null)
                {
                    return 0;
                }
                return ((int)ViewState["OwnerUserID"]);
            }
            set { ViewState["OwnerUserID"] = value; }
        }

        private void DisplayStoryInfo()
        {
            var parsedStoryId = 0;
            if (Request.QueryString["storyid"] == null || int.TryParse(Request.QueryString["storyid"], out parsedStoryId) == false)
            {
                Response.Redirect("/Story/List");
            }
            else
            {
                StoryID = parsedStoryId;

                var drStory = DataFunctions.Records.GetDataRow("SELECT * FROM [StoriesWithDetails] Where StoryID = @ParamOne", 0, StoryID);

                var userLoggedInIsBlocked = false;
                var userViewedIsBlocked = false;
                if (drStory == null)
                {
                    Response.Redirect("/Story/List");
                }
                else
                {
                    //if (bool.Parse(drStory["IsPrivate"].ToString()))
                    //{
                    //    lnkViewWriter.Visible = false;
                    //}
                    //else {
                    UserNav.ItemCreatorID = int.Parse(drStory["UserID"].ToString());

                    //}
                    if (int.Parse(drStory["UniverseID"].ToString()) == 0)
                    {
                        lnkViewUniverse.Visible = false;
                    }
                    else
                    {
                        lnkViewUniverse.NavigateUrl = "/Universe/?id=" + drStory["UniverseID"].ToString();
                    }
                    if (Session["UserID"] != null)
                    {
                        OwnerUserID = int.Parse(drStory["UserID"].ToString());
                        var loggedInUser = (int)Session["UserID"];
                        var intBlockId = DataFunctions.Scalars.GetBlockRecordID(OwnerUserID, loggedInUser);
                        userViewedIsBlocked = (intBlockId != 0); //ViewedUser Is Blocked by LoggedInUser
                        userLoggedInIsBlocked = (DataFunctions.Scalars.GetBlockRecordID(loggedInUser, OwnerUserID) != 0);
                        if (CookieFunctions.IsStaff)
                        {
                            liAdminConsole.Visible = true;
                        }
                    }

                    if (userViewedIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have blocked the owner of this Story. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                        divSubmitPostSection.Visible = false;
                    }
                    else if (userLoggedInIsBlocked)
                    {
                        pnlMessage.Visible = true;
                        pnlMessage.CssClass = "alert alert-danger";
                        litMessage.Text = "It seems you have been blocked by the owner of this Story. Unfortunately, this means that you will not be able to read it.";
                        pnlContent.Visible = false;
                        divSubmitPostSection.Visible = false;
                    }
                    else
                    {
                        BindDataIntoRepeater();
                        //litStoryTitle.Text = drStory["StoryTitle"].ToString();
                        //aTwitterLink.Attributes["data-text"] = "Check out \"" + litStoryTitle.Text + "\" on #RPG!";
                        //Page.Title = litStoryTitle.Text + " — Role-Players Guild";
                        //Page.MetaDescription = "Check out \"" + litStoryTitle.Text + "\" on RPG today! The Role-Players Guild is a fast growing, custom-built role-play community open to writers of all types. If you're looking for the absolute best in role-play, join RPG!";

                        //litStoryDescription.Text = drStory["StoryDescription"].ToString();
                    }
                }
            }
        }
        protected void btnSubmitPost_Click(object sender, EventArgs e)
        {
            if (txtPostContent.Text.Trim().Length > 0)
            {
                DataFunctions.Inserts.InsertRow("INSERT INTO Story_Posts (CharacterID, StoryID, PostContent) VALUES (@ParamOne,@ParamTwo,@ParamThree)", DataFunctions.CurrentSendAsCharacterID, Request.QueryString["storyid"], txtPostContent.Text);
                var ThreadID = DataFunctions.Inserts.CreateNewThread("[RPG] - Story Post Made");
                DataFunctions.Inserts.InsertMessage(ThreadID, 1450, "<div class=\"ThreadAlert alert-info\"><p>A post has been added to a story you own. <a href=\"/Story/Posts/?storyid=" + Request.QueryString["storyid"] + "\">Click here to see the new post</a>.</p></div>");
                DataFunctions.Inserts.InsertThreadUser(OwnerUserID, ThreadID, 2, DataFunctions.Scalars.GetMaxCharacterIdByUser(OwnerUserID), 1);
                NotificationFunctions.NewItemAlert(Request.QueryString["storyid"], DataFunctions.CurrentSendAsCharacterID, "Story Post");
            }
            txtPostContent.Text = "";
            BindDataIntoRepeater();
        }
        protected string DisplayImageString(string imageString, string size)
        {
            return StringFunctions.DisplayImageString(imageString, size);
        }
        protected string ShowTimeAgo(string DateTimeString)
        {
            return StringFunctions.ShowTimeAgo(DateTimeString);
        }
        private static DataTable GetDataFromDb()
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
            con.Open();
            var da = new SqlDataAdapter("Select * From StoryPostsWithCharacterInfo Where StoryID = @StoryID Order By StoryPostID DESC", con);
            da.SelectCommand.Parameters.AddWithValue("StoryID", HttpContext.Current.Request.QueryString["storyid"].ToString());
            var dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return dt;
        }
        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var drv = e.Item.DataItem as DataRowView;
                if (drv == null)
                {
                    return;
                }
                var CharacterID = int.Parse(drv.Row["CharacterID"].ToString());
                var liUserImage = (HtmlGenericControl)(e.Item.FindControl("liUserImage"));
                if (CharacterID == 1450)
                {
                    liUserImage.Visible = false;
                }
                else
                {
                    DateTime dtLastAction;
                    var ShowWhenOnline = drv["ShowWhenOnline"];
                    if (drv["LastAction"] != null &&
                        DateTime.TryParse(drv["LastAction"].ToString(), out dtLastAction) &&
                        dtLastAction > DateTime.Now.AddHours(-3) &&
                        (bool)ShowWhenOnline)
                    {
                        var liUserOnline = (HtmlGenericControl)(e.Item.FindControl("liUserOnline"));
                        liUserOnline.Visible = true;
                        liUserImage.Attributes["class"] += " Online";
                    }
                    else { liUserImage.Attributes["class"] += " Offline"; }
                }
                var liEditMessage = (HtmlGenericControl)(e.Item.FindControl("liEditMessage"));
                var liDeletePost = (HtmlGenericControl)(e.Item.FindControl("liDeletePost"));
                var postUserId = int.Parse(drv.Row["UserID"].ToString());
                if (postUserId == int.Parse(Session["UserID"].ToString()))
                {
                    liEditMessage.Visible = true;
                    liDeletePost.Visible = true;
                }
                if (OwnerUserID == int.Parse(Session["UserID"].ToString()))
                {
                    liDeletePost.Visible = true;
                }
            }
        }
        protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var lnkPage = (LinkButton)e.Item.FindControl("lbPaging");
            if (lnkPage.CommandArgument != CurrentPage.ToString()) return;
            lnkPage.Enabled = false;
            lnkPage.CssClass = "CurrentPage";
        }
        private void BindDataIntoRepeater()
        {
            var dt = GetDataFromDb();
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
            rptMessages.DataSource = _pgsource;
            rptMessages.DataBind();

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
        //    CurrentPage -= 1;
        //    BindDataIntoRepeater();
        //}
        //protected void lbNext_Click(object sender, EventArgs e)
        //{
        //    CurrentPage += 1;
        //    BindDataIntoRepeater();
        //}
        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!e.CommandName.Equals("newPage")) return;
            CurrentPage = Convert.ToInt32(e.CommandArgument.ToString());
            BindDataIntoRepeater();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "linkifyStuffOnNewPage", "$('[data-linkify]').linkify({ target: '_blank', nl2br: true, format: function (value, type) { if (type === 'url' && value.length > 50) { value = value.slice(0, 50) + '…'; } return value; } });", true);
            DisplayStoryInfo();
            Master.PnlLeftCol.CssClass = "col-md-3 col-xl-2";
            Master.PnlRightCol.CssClass = "col-md-9 col-xl-10";
            if (Session["HideAds"] != null && Session["HideAds"].ToString() == "true")
            {
                divThreadAd.Visible = false;
            }
            UserNav.CurrentItemID = int.Parse(Request.QueryString["storyid"]);
        }
        protected void btnDeletePost_Click(object sender, EventArgs e)
        {
            DataFunctions.Deletes.DeleteRows("Delete from Story_Posts where StoryPostID = @ParamOne", hdnPostToDelete.Value);
            BindDataIntoRepeater();
        }
    }
}
