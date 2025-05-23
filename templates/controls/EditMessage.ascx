<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditMessage.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditMessage" %>
<h1>
    <asp:Literal ID="litMessageType" runat="server"></asp:Literal></h1>
<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>
<asp:Panel ID="pnlNewThreadForm" runat="server">
    <asp:Panel runat="server" ID="pnlTitle" class="form-group">
        <label for="txtThreadTitle">Thread Title</label>
        <asp:TextBox ID="txtThreadTitle" runat="server" CssClass="form-control" placeholder="New Thread Title" required autofocus></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvThreadTitle" runat="server" ErrorMessage="You must enter a title." ControlToValidate="txtThreadTitle" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
    </asp:Panel>
    <div class="form-group">
        <label for="txtPasswordConfirm">Invite Others</label>
        Not sure how I'm gonna do this yet...
    </div>
    <div class="form-group">
        <label for="txtPostContent">Initial Post Content</label>
        <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="The message content goes here..." required Rows="12"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPostContent" runat="server" ErrorMessage="You can't create blank threads." ControlToValidate="txtPostContent" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
    </div>
    <asp:Button ID="btnCreateThread" runat="server" Text="Create Thread" CssClass="btn btn-primary" />
</asp:Panel>
