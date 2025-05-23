<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.FunctionalityVoting.Default" %>

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
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a class="btn btn-success" data-toggle="modal" data-target="#AddIdeaModal"><span class="glyphicon glyphicon-plus"></span>&nbsp;New Idea</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
    </div>
    <div class="modal fade" id="AddIdeaModal" tabindex="-1" role="dialog" aria-labelledby="AddIdeaModalLabel">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="AddIdeaModalLabel">Add Idea</h4>
                </div>
                <div class="modal-body FancyCheckList">
                    <asp:FormView ID="FormView1" runat="server" DataKeyNames="ItemID" DataSourceID="sdsToDoItems" DefaultMode="Insert" Width="100%" OnItemInserted="FormView1_ItemInserted">
                        <InsertItemTemplate>
                            <div class="clearfix">
                                <div class="col-sm-6" style="margin: 1em 0;">
                                    <label>Title:</label>
                                    <asp:TextBox ID="ItemNameTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemName") %>' MaxLength="200" required />
                                </div>
                                <div class="col-sm-12" style="margin: 1em 0;">
                                    <label>Description:</label>
                                    <asp:TextBox ID="ItemDescriptionTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemDescription") %>' TextMode="MultiLine" Rows="5" />
                                </div>
                            </div>
                            <div class="col-sm-12 clearfix" style="margin: 1em 0; text-align: right;">
                                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-primary">Submit Idea</asp:LinkButton>
                            </div>
                        </InsertItemTemplate>
                    </asp:FormView>
                </div>
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <script>
                function deactivateButton(theBtn) {
                    $(theBtn).addClass("disabled");
                    $(theBtn).text("Saving...");
                };
            </script>
            <asp:SqlDataSource ID="sdsToDoItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" DeleteCommand="DELETE FROM [ToDo_Items] WHERE [ItemID] = @ItemID" InsertCommand="INSERT INTO [ToDo_Items] ([ItemName], [ItemDescription], [StatusID], [TypeID], [AssignedToUserID], [CreatedByUserID]) VALUES (@ItemName, @ItemDescription, 1, 1, 0, @CreatedByUserID)" SelectCommand="SELECT ItemID, ItemName, TypeName, StatusName, AssignedToUsername, CreatedByUsername, VoteCount, TypeID, StatusID, AssignedToUserID, CreatedByUserID, ItemDescription FROM ToDoItemsWithDetails Where TypeID = 1 AND (StatusID = 1 OR StatusID = 4) Order By VoteCount, ItemID" UpdateCommand="UPDATE [ToDo_Items] SET [ItemName] = @ItemName, [ItemDescription] = @ItemDescription, [StatusID] = @StatusID, [TypeID] = @TypeID, [AssignedToUserID] = @AssignedToUserID, [CreatedByUserID] = @CreatedByUserID, [ThreadID] = @ThreadID WHERE [ItemID] = @ItemID">
                <InsertParameters>
                    <asp:Parameter Name="ItemName" Type="String" />
                    <asp:Parameter Name="ItemDescription" Type="String" />
                    <asp:SessionParameter Name="CreatedByUserID" SessionField="UserID" Type="Int32" />
                </InsertParameters>
            </asp:SqlDataSource>
            <div class="FunctionalitySuggestions">
                <asp:Repeater runat="server" ID="rptToDoItems" DataSourceID="sdsToDoItems" OnItemDataBound="rptToDoItems_ItemDataBound" OnItemCommand="rptToDoItems_ItemCommand">
                    <ItemTemplate>
                        <div class="clearfix Suggestion">
                            <div class="DetailsSection col-sm-9">
                                <label><%# Eval("ItemName") %></label>
                                <span data-linkify><%# Eval("ItemDescription") %></span>
                            </div>
                            <div class="VoteSection col-sm-3">
                                <%# Eval("VoteCount") %>&nbsp;Votes
                        <br />
                                <asp:LinkButton ID="btnAddVote" runat="server" OnClientClick="deactivateButton(this)" CssClass="btn btn-success" Visible="false" CommandName="AddVote" CommandArgument='<%# Eval("ItemID") %>'><span class="glyphicon glyphicon-plus"></span>&nbsp;Vote</asp:LinkButton>
                                <asp:LinkButton ID="btnRemoveVote" runat="server" OnClientClick="deactivateButton(this)" CssClass="btn btn-danger" Visible="false" CommandName="RemoveVote" CommandArgument='<%# Eval("ItemID") %>'>Remove Vote</asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
