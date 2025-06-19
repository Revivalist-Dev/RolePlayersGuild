<%@ Page Title="My Quick Links on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyQuickLinks.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">Add New Quick Link</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-4">
                    <label for="txtLinkName">Link Name</label>
                    <asp:TextBox ID="txtLinkName" runat="server" CssClass="form-control" placeholder="Name of the quick link." required MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLinkName" SetFocusOnError="true" runat="server" ErrorMessage="A Link Name is required." ControlToValidate="txtLinkName" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
                </div>
                <div class="col-sm-4">
                    <label for="txtLinkURL">Link URL</label>
                    <asp:TextBox ID="txtLinkURL" runat="server" CssClass="form-control" placeholder="The URL this link will go to." required MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLinkURL" SetFocusOnError="true" runat="server" ErrorMessage="A URL is required." ControlToValidate="txtLinkURL" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
                </div>
                <div class="col-sm-4">
                    <label for="txtOrderNumber">Order Number</label>
                    <asp:TextBox ID="txtOrderNumber" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                </div>
            </div>
            <div class="ButtonPanel clearfix">
                <div class="col-sm-4 col-xl-2">
                    <asp:Button ID="btnAddQuickLink" runat="server" Text="Add Quick Link" CssClass="btn btn-success btn-block" OnClick="btnAddQuickLink_Click" />
                </div>
                <div class="col-sm-4 col-xl-2"></div>
                <div class="col-sm-4 col-xl-2"></div>
            </div>
        </div>
    </div>
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">My Quick Links</h3>
        </div>
        <div class="panel-body">
            <p>Below is a list of all of your current Quick Links. All of these links will open in a new tab for the purposes of ease-of-use. To add one, use the panel above this. To change one, simply delete and add a replacement.</p>
        </div>
        <div class="list-group">
            <asp:Repeater runat="server" ID="rptQuickLinks" DataSourceID="sdsQuickLinks" OnItemCommand="rptQuickLinks_ItemCommand">
                <ItemTemplate>
                    <div class="list-group-item">
                        <div class=""><%# Eval("OrderNumber") %> - <a href="<%# Eval("LinkAddress") %>" target="_blank"><%# Eval("LinkName") %></a></div>
                        <div class="text-right"><asp:Button runat="server" ID="btnDeleteQuickLink" CommandArgument='<%# Eval("QuickLinkID") %>' CommandName="DeleteQuickLink" Text="Delete Quick Link" CssClass="btn btn-danger btn-sm" CausesValidation="false" formnovalidate /></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="sdsQuickLinks" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [QuickLinks] WHERE ([UserID] = @UserID) Order By OrderNumber, LinkName">
                <SelectParameters>
                    <asp:Parameter Name="UserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <!-- Modules -->
    <div class="modal fade" id="InfoModal" tabindex="-1" role="dialog" aria-labelledby="InfoLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="InfoLabel">What is this?</h4>
                </div>
                <div class="modal-body">
                    <p>Features marked as <span class="label label-warning">Under Development</span> are features that we hope to someday offer to users, but the infrastructure for them has not yet been completed. While the features for these settings may not be finished, however, the option to change your settings for these features is already there and the settings you have now will be kept once those features are in place.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
