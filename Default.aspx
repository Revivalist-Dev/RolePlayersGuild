<%@ Page Title="RPG: For Role-Players By Role-Players" Language="C#" MasterPageFile="~/templates/2-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="For Role-Players by Role-Players. RPG is a role-playing community built with the desires and needs of role-players in mind." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <div id="fb-root"></div>
    <script>(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="rpg-LoginForm">
        <asp:TextBox ID="txtEmailAddress" runat="server" CssClass="form-control" TextMode="Email" placeholder="Email Address" required autofocus></asp:TextBox>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password" required></asp:TextBox>
        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />
        <a href="/Register/" class="btn btn-default btn-block">Register</a>
        <div class="text-center"><a class="btn btn-link" href="/Account-Recovery/">Forgot your password?</a></div>
    </div>

    <div class="fb-like" data-href="https://www.facebook.com/RolePlayersGuildCom/" data-layout="button_count" data-action="like" data-show-faces="true" data-share="true"></div>
    <p style="margin-top: 5px;">
        <a href="https://twitter.com/RPers_Guild" class="twitter-follow-button" data-show-count="false">Follow @RPers_Guild</a>
    </p>
    <div style="text-align: center;" class="hidden-xs">
        <a class="twitter-timeline" href="https://twitter.com/RPers_Guild" data-widget-id="713438449467043840">Tweets by @RPers_Guild</a>
    </div>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + "://platform.twitter.com/widgets.js"; fjs.parentNode.insertBefore(js, fjs); } }(document, "script", "twitter-wjs");</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <h1>Welcome to the Role-Players Guild</h1>
    <p>
        Thank you for visiting our little site. The Role-Players Guild was built in order to deliver a community to Role-Players that is actually built from the ground up for their needs and desires. It's a website built on the feedback of the users and because of that, we are always, actively making changes to the website to make it better for role-play and not littering it with features that no one wants.
    </p>
    <div runat="server" id="RecentArticleListing" class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">New Articles</h3>
        </div>

        <ul class="list-group">
            <asp:Repeater ID="rptArticles" runat="server" DataSourceID="sdsArticles">
                <ItemTemplate>
                    <li class="list-group-item">[<%# Eval("ContentRating") %>] - <a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a> by <%# Eval("Username") %></li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <asp:SqlDataSource ID="sdsArticles" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top (5) * FROM [ArticlesForListing] WHERE (CategoryID <> 7 AND CategoryID <> 8 AND CategoryID <> 9 AND CategoryID <> 10) ORDER BY [CreatedDateTime] DESC"></asp:SqlDataSource>
        <div class="panel-footer text-right small">
            <a href="/Article/List/">View All Articles</a>
        </div>
    </div>
    <uc1:CharacterListing runat="server" ID="CharacterListing" ScreenStatus="NewCharactersNoAuth" RecordCount="12" />

    <div style="text-align: center;" class="visible-xs">
        <a class="twitter-timeline" href="https://twitter.com/RPers_Guild" data-widget-id="713438449467043840">Tweets by @RPers_Guild</a>
    </div>

</asp:Content>
