<%@ Page Title="My Settings on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyWriting.EditProfile.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <h1>
    Edit Writer Profile</h1>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <ul>
            <li class="col-sm-4 col-xl-3">
                <a href="/My-Writing/" class="btn btn-default">Back To My Writing</a>
            </li>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3 col-xl-offset-3">
                <asp:HyperLink CssClass="btn btn-default" runat="server" ID="lnkViewProfile">View My Profile</asp:HyperLink>               
            </li>
        </ul>
    </div>
    <div class="form-group">
        <label for="txtAboutMe">About Me</label>
        <asp:TextBox ID="txtAboutMe" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="Info about yourself. HTML is allowed." Rows="12" ValidateRequestMode="Disabled"></asp:TextBox>
    </div>
    <div class="ButtonPanel clearfix">
        <ul>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3 col-xl-offset-3">
                <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile" CssClass="btn btn-primary" OnClick="btnSaveProfile_Click" />
            </li>
        </ul>
    </div>
</asp:Content>
