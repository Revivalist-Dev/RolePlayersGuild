<%@ Page Title="Admin Console on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <ul ID="ulAdminNav" runat="server" class="ListNav">
        <li ID="liCharactersUnderReviewListing" runat="server"><a href="/Admin/Characters-Under-Review/" class="btn btn-primary staff">Under Review</a></li>
        <li ID="liCharacterListing" runat="server"><a href="/Admin/Characters/" class="btn btn-primary staff">Character Listing</a></li>
        <li ID="liUserListing" runat="server"><a href="/Admin/Users/" class="btn btn-primary staff">User Listing</a></li>
        <li ID="liToDoItems" runat="server"><a href="/Admin/ToDo/" class="btn btn-primary staff">To-Do Items</a></li>
        <li ID="liMassMessage" runat="server"><a class="btn btn-primary staff" href="/Admin/Mass-Message/">Mass Message</a></li>
        <li ID="liArticles" runat="server"><a href="/Admin/Articles/" class="btn btn-primary staff">Articles</a></li>
        <li ID="liUniverses" runat="server"><a href="/Admin/Universes/" class="btn btn-primary staff">Universes</a></li>
        <li ID="liChatRooms" runat="server"><a href="/Admin/Chat-Rooms/" class="btn btn-primary staff">Chat Rooms</a></li>
        <li ID="liStories" runat="server"><a class="btn btn-primary staff" href="/Admin/Stories/">Stories</a></li>
        <li ID="liSiteRules" runat="server"><a class="btn btn-primary staff" href="/Admin/Site-Rules/">Site Rules</a></li>
        <li ID="liSiteFundingGoals" runat="server"><a class="btn btn-primary staff" href="/Admin/Site-Funding-Goal/">Funding Goal</a></li>
        <li ID="liSitePrivacyPolicy" runat="server"><a class="btn btn-primary staff" href="/Admin/Site-Privacy-Policy/">Privacy Policy</a></li>
        <li ID="liSitePurge" runat="server"><a class="btn btn-primary staff" href="/Admin/Purge/AutomatedPurge.aspx">Regular Purge</a></li>
    </ul>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
