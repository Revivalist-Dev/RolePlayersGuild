<%@ Page Title="Change Password on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MySettings.ChangePassword" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <fieldset class="MySettings">
        <legend>Change Password</legend>
        <div class="form-group">
            <label for="txtCurrentPassword">Current Password</label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your current password." TextMode="Password" required autofocus MaxLength="50"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtNewPassword">New Password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your new password." TextMode="Password"  required></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtNewPasswordConfirm">Confirm New Password</label>
            <asp:TextBox ID="txtNewPasswordConfirm" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your new password again." TextMode="Password"  required></asp:TextBox>
        </div>
        <div class="ButtonPanel clearfix">
            <ul>
                <li class="col-sm-4 col-xl-2">
                    <asp:Button ID="btnSaveSettings" runat="server" Text="Save My Password" CssClass="btn btn-primary" OnClick="btnSaveSettings_Click" />
                </li>
                <li class="col-sm-4 col-xl-2"></li>
                <li class="col-sm-4 col-xl-2">
                    <a href="/My-Settings/" class="btn btn-danger">Cancel</a>
                </li>
            </ul>
        </div>
    </fieldset>
</asp:Content>
