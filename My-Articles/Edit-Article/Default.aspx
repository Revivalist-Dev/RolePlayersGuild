<%@ Page Title="Edit Article" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyArticles.EditArticle.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>
<%@ Register Src="~/templates/controls/EditArticle.ascx" TagPrefix="uc1" TagName="EditArticle" %>



<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <uc1:EditArticle runat="server" id="EditArticle" />
</asp:Content>
