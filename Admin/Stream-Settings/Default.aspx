<%@ Page Title="Change Stream Settings on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.StreamSettings.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>
    <div class="clearfix">       
        <div class="col-sm-12" style="margin: 1em 0;">
            <label>RP Setting:</label>
            <asp:TextBox ID="txtSettingInfo" runat="server" Width="100%" Rows="15" TextMode="MultiLine" CssClass="form-control" ValidateRequestMode="Disabled" placeholder="Try to use HTML, please. Make sure there is a location with detailed information."></asp:TextBox>
        </div>
    </div>
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <asp:Button ID="btnSaveSetting" runat="server" Text="Save Settings" CssClass="btn btn-success" OnClick="btnSaveSetting_Click" />
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
