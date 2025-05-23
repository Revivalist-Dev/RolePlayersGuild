<%@ Page Title="My Dashboard on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyDashboard.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>
<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>
<%@ Register Src="~/templates/controls/VotePrompt.ascx" TagPrefix="uc1" TagName="VotePrompt" %>




<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <div runat="server" id="divAdminNotic" visible="false" class="alert alert-warning"></div>
    <uc1:VotePrompt runat="server" ID="VotePrompt" />
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a href="https://twitter.com/RPers_Guild" target="_blank" class="btn btn-default btn-twitter">Follow us on Twitter!</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a href="https://www.facebook.com/RolePlayersGuildCom/" target="_blank" class="btn btn-default btn-facebook">Like us on Facebook!</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a href="/Character-Art-Commissions/" class="btn btn-default">Commission Character Art</a>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">RPG Keep-Alive Funding Goal</h3>
                </div>
                <div class="panel-body" style="text-align: center;">
                    <div style="width: 100%; border: 1px solid white; background: black;">
                        <div runat="server" id="divProgressBar"></div>
                    </div>
                    <p>
                    We're at $<asp:Literal runat="server" ID="litAtDollarAmount"></asp:Literal>
                    of our $400 Monthly Goal!
                    </p>
                        <input type="hidden" name="custom" value="<%= CurrentUserID() %>">
                        <input type="hidden" name="cmd" value="_s-xclick">
                        <input type="hidden" name="hosted_button_id" value="D4UR4R8SFH79C">
                        <asp:Button ID="btnDonate" runat="server" Text="Donate via PayPal" Style="margin-bottom: 5px;" PostBackUrl="https://www.paypal.com/cgi-bin/webscr" CssClass="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-6">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Invite Your Friends</h3>
                </div>
                <div class="panel-body MinHeightOnDashboard">
                    <p>Looking to score a Recruiter badge? Use the URL below to invite your friends to RPG and you'll automatically get a Recruiter badge! </p>
                    <p>
                        <input type="text" value="http://www.roleplayersguild.com?ReferralID=<%= CurrentUserID() %>" style="width: 100%; border-radius: 5px; border: 1px solid #DDD; padding: .5em 1em; outline: none; box-shadow: inset 0px 0px 60px -15px grey; cursor: text;" readonly="readonly"/>
                    </p>
                </div>
                <div class="panel-footer text-right small">
                    <a href="/FAQ/">Frequently Asked Questions</a>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Blog Posts</h3>
                </div>
                <ul class="list-group">
                    <asp:Repeater ID="rptBlogPosts" runat="server" DataSourceID="xdsBlogPosts">
                        <ItemTemplate>
                            <li class="list-group-item"><a href="<%# XPath("link") %>" target="_blank"><%# XPath("title") %></a> - <%# DateTime.Parse(XPath("pubDate").ToString()).ToString("MMMM dd, yyyy") %></li>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:XmlDataSource ID="xdsBlogPosts" runat="server" DataFile="http://roleplayersguild.blog/feed/" XPath="/rss/channel/item[position() < 6]"></asp:XmlDataSource>
                </ul>
                <div class="panel-footer text-right small">
                    <a href="http://roleplayersguild.blog" target="_blank">View All Blog Posts</a>
                </div>
            </div>
        </div>

    </div>
    <div class="row">
        <div class="col-lg-6">
            <div runat="server" id="ActiveChatRoomListing" class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Active Chat Rooms</h3>
                </div>
                <asp:SqlDataSource ID="sdsActiveChatRooms" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT TOP (5) * FROM [ActiveChatrooms] Where ChatroomID not in (Select ChatroomID from Chat_Room_Locks where UserID = @UserID) And SubmittedByUserID not in (Select UserBlocked from User_Blocking Where UserBlockedBy = @UserID) And SubmittedByUserID not in (Select UserBlockedBy from User_Blocking Where UserBlocked = @UserID) ORDER BY [LastPostTime] DESC;">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <ul class="list-group">
                    <asp:Repeater ID="rptChatRooms" runat="server" DataSourceID="sdsActiveChatRooms">
                        <ItemTemplate>
                            <li class="list-group-item"><a href="/Chat-Rooms/Room/?Via=ActiveChatList&id=<%# Eval("ChatRoomID") %>"><%# Eval("ChatRoomName") %></a> - [<%# Eval("ContentRating") %>] - Last Post: <%# GetTimeAgo(Eval("LastPostTime").ToString()) %></li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <div class="panel-footer text-right small">
                    <a href="/My-Chat-Rooms/">My Chat Rooms</a>
                    |
            <a href="/Chat-Rooms/">View All Chat Rooms</a>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div runat="server" id="RecentStoriesListing" class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Popular Stories</h3>
                </div>

                <ul class="list-group">
                    <asp:Repeater ID="rptStories" runat="server" DataSourceID="sdsStories">
                        <ItemTemplate>
                            <li class="list-group-item"><%# Eval("StoryTitle") %> - <a href="/Story/?id=<%# Eval("StoryID") %>">Details</a> | <a href="/Story/Posts/?storyid=<%# Eval("StoryID") %>">Posts</a></li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <asp:SqlDataSource ID="sdsStories" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top (5) * FROM [PopularStories] Where UserID not in (Select UserBlocked from User_Blocking Where UserBlockedBy = @UserID) And UserID not in (Select UserBlockedBy from User_Blocking Where UserBlocked = @UserID) ORDER BY [LastPostDateTime] DESC;">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div class="panel-footer text-right small">
                    <a href="/My-Stories/">My Stories</a>
                    |
                    <a href="/Story/List/">View All Stories</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div runat="server" id="RecentArticleListing" class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Newest Articles</h3>
                </div>

                <ul class="list-group">
                    <asp:Repeater ID="rptArticles" runat="server" DataSourceID="sdsArticles">
                        <ItemTemplate>
                            <li class="list-group-item">[<%# Eval("ContentRating") %>] - <a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a> by <%# Eval("Username") %> - <%# Eval("CategoryName") %></li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <asp:SqlDataSource ID="sdsArticles" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top (5) * FROM [ArticlesForListing] WHERE (CategoryID <> 7 AND CategoryID <> 8 AND CategoryID <> 9 AND CategoryID <> 10) AND OwnerUserID not in (Select UserBlocked from User_Blocking Where UserBlockedBy = @UserID) And OwnerUserID not in (Select UserBlockedBy from User_Blocking Where UserBlocked = @UserID) ORDER BY [CreatedDateTime] DESC;">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div class="panel-footer text-right small">
                    <a href="/My-Articles/">My Articles</a>
                    |
            <a href="/Article/List/">View All Articles</a>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div runat="server" id="PeopleLookingForRP" class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Looking for Role-Play</h3>
                </div>

                <ul class="list-group">
                    <asp:Repeater ID="rptLFRP" runat="server" DataSourceID="sdsLFRP">
                        <ItemTemplate>
                            <li class="list-group-item">[<%# Eval("ContentRating") %>] - <a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a></li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <asp:SqlDataSource ID="sdsLFRP" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top (5) * FROM [ArticlesForListing] WHERE CategoryID = 7 AND OwnerUserID not in (Select UserBlocked from User_Blocking Where UserBlockedBy = @UserID) And OwnerUserID not in (Select UserBlockedBy from User_Blocking Where UserBlocked = @UserID) ORDER BY [CreatedDateTime] DESC">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div class="panel-footer text-right small">
                    <a href="/My-Articles/">My Articles</a>
                    |
            <a href="/Article/List/">View All Articles</a>
                </div>
            </div>
        </div>
    </div>
    <div class="FrontPageCharacterList">
        <uc1:CharacterListing runat="server" ID="CharacterListing1" ScreenStatus="OnlineCharacters" RecordCount="12" />
        <uc1:CharacterListing runat="server" ID="CharacterListing2" ScreenStatus="NewCharacters" RecordCount="12" />
    </div>
    <%--    <div class="alert alert-warning">
        <p>WHERE IS THE CHAT?!</p>
           <p>Great job... you frickin' broke it. Now what? Oh, you're sorry? How is that going to fix the chat? Classic... you...</p>
           <p>Nah, I'm just kidding. Click on the "Public Areas" navigation item over on the left... or up above this if you're on mobile.</p>
        <p>-Villanite</p>
    </div>--%>
    <%-- <div>
        <iframe src="http://www.chatzy.com/frame/roleplayersguild" width="100%" style="border: none; height: 500px; border-radius:10px;"></iframe>
    </div>--%>
    <%--    <div runat="server" id="divChatArea">
        <uc1:ChatRoom runat="server" id="ChatRoom" ChatRoomID="1" />
    </div>--%>
    <%--<div runat="server" id="divUpdateStream">
        <uc1:UpdateStream runat="server" ID="UpdateStream" />
    </div>--%>
</asp:Content>
