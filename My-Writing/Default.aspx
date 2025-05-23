<%@ Page Title="My Writing on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyWriting.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <fieldset class="MyWriting">
        <legend>My Writing</legend>
        <div class="ButtonPanel clearfix">
            <ul>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Writing/Edit-Profile/" class="btn btn-default">Edit Writer Profile</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Articles/" class="btn btn-default">Manage Articles</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Characters/" class="btn btn-default">Manage Characters</a>
                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Universes/" class="btn btn-default">Manage Universes</a>

                </li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Chat-Rooms/" class="btn btn-default">Manage Chat Rooms</a>

                </li>
            </ul>
        </div>
    </fieldset>
</asp:Content>
