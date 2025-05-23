<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyCharacters.EditCharacter.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>
<%@ Register Src="~/templates/controls/EditCharacter.ascx" TagPrefix="uc1" TagName="EditCharacter" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlWelcomeMessage" runat="server" CssClass="alert alert-success" Visible="false">    
        <h2>Welcome to RPG!</h2>
        <p>Welcome and thank you for joining the Role-Players Guild! As you may already know, RPG is built from the ground up to cater to the needs and desires of the RP community. This isn't just some forum site or social media tool that is used for RP, it is a website made specifically for RP.</p>
        <p>As a member of RPG, you are now part of our beautiful and growing family. Please make sure you are respectful to all the other members and if anyone is disrespectful to you, please let us know <strong>right away</strong>.</p>
        <p>With that, it's time for you to join us! Below, you can make your very first character! Please note that you must do this before using any more of the website while logged in.</p>        
        <br />
        <p>Thank you,</p>
        <p>RPG Staff</p>
    </asp:Panel>
    <uc1:EditCharacter runat="server" id="EditCharacter" />
</asp:Content>
