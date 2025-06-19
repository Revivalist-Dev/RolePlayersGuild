<%@ Page Title="" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Article.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>


<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <div id="fb-root"></div>
    <script>(function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + '://platform.twitter.com/widgets.js'; fjs.parentNode.insertBefore(js, fjs); } }(document, 'script', 'twitter-wjs');</script>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <div class="col-sm-3 col-xs-12">
            <a href="/Article/List/" class="btn btn-default">Back To Articles</a>
        </div>
        <div class="col-sm-3 col-xs-12">
            <asp:HyperLink ID="lnkViewWriter" runat="server" Text="View Writer" CssClass="btn btn-primary" />
        </div>
        <div class="col-sm-3 col-xs-12">
            <asp:HyperLink ID="lnkViewUniverse" runat="server" Text="View Universe" CssClass="btn btn-primary" />
        </div>
        <div runat="server" id="liAdminConsole" class="col-sm-3 col-xs-12" visible="false">
            <a href="/Admin/Articles?id=<%= Request.QueryString["id"].ToString() %>" class="btn btn-primary staff">Admin Console</a>
        </div>
    </div>

    <asp:Panel ID="pnlContent" runat="server">
        <div class="SocialLinks">
            <a runat="server" id="aTwitterLink" href="https://twitter.com/share" class="twitter-share-button" data-text="Read this article!" data-hashtags="RolePlayersGuild">Tweet</a>
            <div class="fb-share-button" data-href="http://www.roleplayersguild.com/Character?id=<%= Request.QueryString["id"] %>" data-layout="button"></div>
        </div>
        <h1 class="text-center">
            <asp:Literal ID="litArticleTitle" runat="server"></asp:Literal></h1>

        <div id="divArticleContentContainer" runat="server" style="margin-bottom: 20px;">
            <asp:Literal ID="litArticleContent" runat="server"></asp:Literal>
            <!--Spacer line.-->
        </div>
    </asp:Panel>
</asp:Content>


