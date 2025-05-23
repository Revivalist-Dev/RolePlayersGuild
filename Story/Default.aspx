<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Story.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" CurrentParent="Stories" />
    <div runat="server" id="divThreadAd">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- ThreadsAd -->
        <ins class="adsbygoogle"
            style="display: block"
            data-ad-client="ca-pub-1247828126747788"
            data-ad-slot="7028871313"
            data-ad-format="auto"></ins>
        <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphRightCol" runat="server">
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
            <a href="/Story/List/" class="btn btn-default">Back To Stories</a>
        </div>
        <div class="col-sm-3 col-xs-12">
        </div>
        <div class="col-sm-3 col-xs-12">
            <asp:HyperLink ID="lnkViewUniverse" runat="server" Text="View Universe" CssClass="btn btn-primary" />
        </div>
        <div runat="server" id="liAdminConsole" class="col-sm-3 col-xs-12" visible="false">
            <a href="/Admin/Stories?id=<%= Request.QueryString["id"].ToString() %>" class="btn btn-primary staff">Admin Console</a>
        </div>
    </div>

    <asp:Panel ID="pnlContent" runat="server" CssClass="col-xs-12">
        <div class="SocialLinks">
            <a runat="server" id="aTwitterLink" href="https://twitter.com/share" class="twitter-share-button" data-text="Read this Story!" data-hashtags="RolePlayersGuild">Tweet</a>
            <div class="fb-share-button" data-href="http://www.roleplayersguild.com/Character?id=<%= Request.QueryString["id"] %>" data-layout="button"></div>
        </div>
        <asp:Panel ID="pnlRatingNotice" runat="server">
            <asp:Literal ID="litRatingNotice" runat="server"></asp:Literal>
        </asp:Panel>

        <h1 class="text-center">
            <asp:Literal ID="litStoryTitle" runat="server"></asp:Literal></h1>

        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">Story Description</h3>
            </div>
            <div class="panel-body story-styled" data-linkify="">
                <asp:Literal ID="litStoryDescription" runat="server"></asp:Literal>
                <!--Spacer line.-->
            </div>
        </div>
    </asp:Panel>
</asp:Content>


