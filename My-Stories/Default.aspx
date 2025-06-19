<%@ Page Title="My Stories on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyStories.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <ul>
            <li class="col-sm-4 col-xl-3">
                <a href="/My-Writing/" class="btn btn-default">Back To My Writing</a>
            </li>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Stories/Edit-Story?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Story</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>My Stories</legend>
        <div class="WritingContentList">
            <asp:Repeater ID="rptStories" runat="server" DataSourceID="sdsStories" OnItemDataBound="rptStories_ItemDataBound">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/My-Stories/Edit-Story?Mode=Edit&id=<%# Eval("StoryID") %>" class="WritingContentName"><%# Eval("StoryTitle") %> &raquo;</a>
                            <div class="WritingContentDetails">
                                <ul class="Info">
                                    <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
                                </ul>
                                <ul class="Genres">
                                    <asp:Repeater ID="rptGenres" runat="server">
                                        <ItemTemplate>
                                            <li><%# Eval("GenreName") %></li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:SqlDataSource ID="sdsStories" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [StoriesForListing] WHERE (UserID = @UserID) Order By StoryTitle">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Story_Genres.StoryID, Genres.GenreName FROM Story_Genres INNER JOIN Genres ON Story_Genres.GenreID = Genres.GenreID WHERE (Story_Genres.StoryID = @StoryID)">
            <SelectParameters>
                <asp:Parameter Name="StoryID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
