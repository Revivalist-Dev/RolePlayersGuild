<%@ Page Title="My Settings on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MySettings.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <ul>
            <li class="col-sm-4 col-xl-2">
                <a href="/My-Settings/Change-Password/" class="btn btn-default">Change Password</a>
            </li>
            <li class="col-sm-4 col-xl-2">
            </li>
            <li class="col-sm-4 col-xl-2">
                <asp:HyperLink runat="server" ID="lnkSubscribeButton" NavigateUrl="/Memberships/" CssClass="btn btn-success" Visible="false">Buy Paid Membership</asp:HyperLink>
                <asp:HyperLink runat="server" ID="lnkUnsubscribeButton" NavigateUrl="https://www.paypal.com/cgi-bin/webscr?cmd=_subscr-find&alias=QKT27G6U65P54" CssClass="btn btn-danger" Visible="false">Cancel Paid Membership</asp:HyperLink>
            </li>
        </ul>
    </div>
    <fieldset class="MySettings">
        <legend>My Settings</legend>
        <div class="form-group">
            <label for="txtUsername">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your general username." required autofocus MaxLength="50"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtEmailAddress">Email Address</label>
            <asp:TextBox ID="txtEmailAddress" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your email address." required></asp:TextBox>
        </div>
        <asp:Panel ID="pnlReferralSettings" runat="server" Visible="false">
            <asp:Panel ID="pnlReferralMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
                <asp:Literal ID="litReferralMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
            </asp:Panel>
            <div class="form-group">
                <label for="txtReferralID">Referred By</label>
                <asp:TextBox ID="txtReferralID" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="ID number of the writer who referred you."></asp:TextBox>
            </div>

        </asp:Panel>
        <label>Privacy</label>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkShowWhenOnline" ClientIDMode="Static" runat="server" Text="" />
                Show other users when I'm online.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkShowWriterLinkOnCharacters" ClientIDMode="Static" runat="server" Text="" />
                Show link to Writer Profile on Character Profiles.
            </label>
        </div>

        <label>Emails</label>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkThreadNotifications" ClientIDMode="Static" runat="server" Text="" />
                Send me email notifications when someone posts on a Thread I am involved in.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkImageCommentNotifications" ClientIDMode="Static" runat="server" Text="" />
                Send me email notifications when someone comments on one of my Images.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkWritingCommentNotifications" ClientIDMode="Static" runat="server" Text="" />
                <a class="label label-warning" data-toggle="modal" data-target="#InfoModal">Under Development</a> Send me email notifications when someone comments on my Writing.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkDevUpdates" ClientIDMode="Static" runat="server" Text="" />
                Send me emails about development and new features.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkErrors" ClientIDMode="Static" runat="server" Text="" />
                Send me emails when particular errors have been fixed.
            </label>
        </div>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkEmailBlasts" ClientIDMode="Static" runat="server" Text="" />
                Send me other types of general newsletter emails.
            </label>
        </div>
        <label>Mature Content</label>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkMatureContent" ClientIDMode="Static" runat="server" Text="" />
                <a class="label label-warning" data-toggle="modal" data-target="#InfoModal">Under Development</a>
                I am old enough to view mature content and interact with people who create/share it.                                
            </label>
        </div>
        <label>Other</label>
        <div class="checkbox">
            <label>
                <asp:CheckBox ID="chkUseDarkTheme" ClientIDMode="Static" runat="server" Text="" />
                Use the Dark RPG Theme.
            </label>
        </div>
        <div class="ButtonPanel clearfix">
            <ul>
                <li class="col-sm-4 col-xl-2">
                    <asp:Button ID="btnSaveSettings" runat="server" Text="Save My Settings" CssClass="btn btn-primary" OnClick="btnSaveSettings_Click" />
                </li>
                <li class="col-sm-4 col-xl-2"></li>
                <li class="col-sm-4 col-xl-2"></li>
            </ul>
        </div>
    </fieldset>

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
