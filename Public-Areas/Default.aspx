<%@ Page Title="Public Areas on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.PublicAreas.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <fieldset class="PublicAreas">
        <legend>Public Areas</legend>
        <div class="alert alert-info">The areas listed below should be understood to be completely public. Anything found in these areas of RPG will be visible to all users (and in some cases, un-registered visitors). Please be respectful of others and be sure to follow any listed rules of each area.</div>
        <div class="ButtonPanel clearfix">
            <ul>
                <li class="col-sm-4 col-xl-2">
                    <a href="/Article/List/" class="btn btn-default">Articles</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/Universe/List/" class="btn btn-default">Universes</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/Chat-Rooms/" class="btn btn-default">Chat Rooms</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/Story/List/" class="btn btn-default">Stories</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/Character/Search" class="btn btn-default">Character Search</a>
                </li>
            </ul>
        </div>
    </fieldset>
</asp:Content>
