<%@ Page Title="Stream Archive on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.StreamArchive.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <asp:Button ID="btnPurgeStream" runat="server" Text="Purge Stream" CssClass="btn btn-danger" OnClick="btnPurgeStream_Click" />
        </div>
    </div>
    <div class="StreamPosts">
        <asp:Repeater ID="rptSteamPosts" runat="server" DataSourceID="sdsStreamPosts">
            <ItemTemplate>
                <div class="Post">
                    <div class="PostDetails clearfix">
                        <div class="Content col-xs-10">
                            <strong class="CharacterName"><a class="<%# StaffClass(Eval("IsStaff")) %>" href="/Character?id=<%# Eval("StreamPostMadeByCharacterID") %>"><%# Eval("CharacterDisplayName") %></a><span class="TimeStamp"> <%# Eval("StreamPostCreatedDateTime").ToString() %> Pacific</span></strong>
                            <span data-linkify><%# Eval("StreamPostContent") %></span>
                        </div>
                    </div>
                    <div class="Options"></div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="sdsStreamPosts" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [StreamUpdatesWithDetails] ORDER BY [StreamPostCreatedDateTime] DESC">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
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
