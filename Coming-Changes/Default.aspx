<%@ Page Title="RPG: Coming Changes" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.ComingChanges.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="This website is built soley based on the desires, needs and preferences of the community. Here is a public list of features under consideration and changes that are on the way!" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Coming Changes</h1>
    <p>Below are publicly displayed the features that are coming to RPG. The first list shows what items are currently under development and the second list shows the features that are suggested and being voted for by the community and are currently under consideration.</p>

    <h2>Under Development</h2>
    <div class="FunctionalitySuggestions">
        <asp:SqlDataSource ID="sdsDevItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT ItemID, ItemName, TypeName, StatusName, AssignedToUsername, CreatedByUsername, VoteCount, TypeID, StatusID, AssignedToUserID, CreatedByUserID, ItemDescription FROM ToDoItemsWithDetails Where TypeID = 2 AND StatusID = 4 AND AssignedToUserID = 2 Order By ItemID"></asp:SqlDataSource>
        <asp:Repeater runat="server" ID="rptDevItems" DataSourceID="sdsDevItems">
            <ItemTemplate>
                <div class="clearfix Suggestion">
                    <div class="DetailsSection col-sm-12">
                        <label><%# Eval("ItemName") %></label>
                        <span data-linkify><%# Eval("ItemDescription") %></span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <h2>Under Consideration</h2>
    <div class="FunctionalitySuggestions">
        <asp:SqlDataSource ID="sdsToDoItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT ItemID, ItemName, TypeName, StatusName, AssignedToUsername, CreatedByUsername, VoteCount, TypeID, StatusID, AssignedToUserID, CreatedByUserID, ItemDescription FROM ToDoItemsWithDetails Where TypeID = 1 AND (StatusID = 1 OR StatusID = 4) Order By VoteCount DESC, ItemID"></asp:SqlDataSource>
        <asp:Repeater runat="server" ID="rptToDoItems" DataSourceID="sdsToDoItems">
            <ItemTemplate>
                <div class="clearfix Suggestion">
                    <div class="DetailsSection col-sm-12">
                        <label><%# Eval("ItemName") %></label>
                        <span data-linkify><%# Eval("ItemDescription") %></span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
