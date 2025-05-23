<%@ Page Title="Send Mass Message on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.Mass_Message.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <script>
        function deactivateButton(theBtn) {
            setTimeout(function () {
                $(theBtn).prop("disabled", true);
                $(theBtn).addClass("disabled");
                $(theBtn).prop("value", "Please Wait...");
            }, 100);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>
    <div class="clearfix">
        <div class="col-sm-6" style="margin: 1em 0;">
            <label>Title:</label>
            <asp:TextBox ID="txtMessageTitle" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="col-sm-12" style="margin: 1em 0;">
            <label>Message:</label>
            <asp:TextBox ID="txtMassMessage" runat="server" Width="100%" Rows="15" TextMode="MultiLine" CssClass="form-control" ValidateRequestMode="Disabled"></asp:TextBox>
        </div>
    </div>
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <asp:Button ID="btnSendMessage" runat="server" Text="Send Mass Message" OnClientClick="deactivateButton(this)" OnClick="Button1_Click" CssClass="btn btn-primary" />
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
