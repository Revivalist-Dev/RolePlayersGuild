<%@ Page Title="My Articles on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyArticles.Default" %>

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
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Articles/Edit-Article?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Article</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>My Articles</legend>
        <div class="WritingContentList">
            <asp:Repeater ID="rptArticles" runat="server" DataSourceID="sdsArticles" OnItemDataBound="rptArticles_ItemDataBound">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/My-Articles/Edit-Article?Mode=Edit&id=<%# Eval("ArticleID") %>" class="WritingContentName"><%# Eval("ArticleTitle") %> &raquo;</a>
                            <div class="WritingContentDetails">
                                <ul class="Info">
                                    <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
                                    <li><span>Category:</span> <%# Eval("CategoryName") %></li>
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
        <asp:SqlDataSource ID="sdsArticles" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ArticlesForListing] WHERE (OwnerUserID = @UserID) Order By ArticleTitle">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Article_Genres.ArticleID, Genres.GenreName FROM Article_Genres INNER JOIN Genres ON Article_Genres.GenreID = Genres.GenreID WHERE (Article_Genres.ArticleID = @ArticleID)">
            <SelectParameters>
                <asp:Parameter Name="ArticleID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
