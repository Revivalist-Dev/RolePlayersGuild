<%@ Page Title="RPG: Badge Listing" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Badge.List.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Earn badges by joining RPG and completing various achievements!" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Available Badges</h1>
    <div class="AvailableBadgeListing clearfix">
        <asp:Repeater ID="rptBadges" runat="server" DataSourceID="sdsBadges">
            <ItemTemplate>
                <div class="col-sm-6 col-md-4 col-lg-3 col-xl-2">
                    <div class="Badge">
                        <div class="Title">
                            <a href="#" class="<%# Eval("CharacterNameClass") %>"><%# Eval("BadgeName") %></a>
                        </div>
                        <img src="<%# Eval("BadgeImageURL") %>" />
                        <span><%# Eval("HowToGetBadge") %></span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:SqlDataSource ID="sdsBadges" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT BadgeName, BadgeImageURL, HowToGetBadge, CharacterNameClass FROM Badges ORDER BY SortOrder"></asp:SqlDataSource>
</asp:Content>
